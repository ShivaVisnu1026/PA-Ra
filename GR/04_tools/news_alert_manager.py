#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
News Alert Manager
Manages keyword-based alerts for important news articles
"""

import json
import os
import re
from datetime import datetime
from typing import List, Dict, Optional, Set
from dataclasses import dataclass, asdict
from enum import Enum


class AlertPriority(Enum):
    """Alert priority levels"""
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"


@dataclass
class AlertRule:
    """Alert rule definition"""
    keywords: List[str]
    priority: str
    enabled: bool = True
    case_sensitive: bool = False
    whole_word: bool = False

    def matches(self, text: str) -> bool:
        """Check if text matches this rule"""
        if not self.enabled:
            return False
        
        search_text = text if self.case_sensitive else text.lower()
        
        for keyword in self.keywords:
            search_keyword = keyword if self.case_sensitive else keyword.lower()
            
            if self.whole_word:
                # Match whole words only
                pattern = r'\b' + re.escape(search_keyword) + r'\b'
                if re.search(pattern, search_text, re.IGNORECASE if not self.case_sensitive else 0):
                    return True
            else:
                # Match anywhere
                if search_keyword in search_text:
                    return True
        
        return False


@dataclass
class Alert:
    """Alert data structure"""
    title: str
    url: str
    source: str
    priority: str
    matched_keywords: List[str]
    timestamp: str
    content_preview: str

    def __post_init__(self):
        if not self.timestamp:
            self.timestamp = datetime.now().isoformat()


class AlertManager:
    """Manages alert rules and notifications"""

    def __init__(self, config: Optional[Dict] = None):
        """Initialize alert manager with configuration"""
        if config is None:
            config = {}
        
        self.alert_config = config.get('alert_settings', {})
        self.enabled = self.alert_config.get('enabled', True)
        self.keywords = self.alert_config.get('keywords', {})
        self.notification_channels = self.alert_config.get('notification_channels', {})
        self.alert_file_path = self.alert_config.get('alert_file_path', 'DaTa/News/Alerts/alerts.json')
        
        # Build alert rules from keywords
        self.rules = self._build_rules()
        
        # Alert history
        self.alerts: List[Alert] = []
        
        # Ensure alert directory exists
        alert_dir = os.path.dirname(self.alert_file_path)
        if alert_dir:
            os.makedirs(alert_dir, exist_ok=True)

    def _build_rules(self) -> List[AlertRule]:
        """Build alert rules from configuration"""
        rules = []
        
        # High priority keywords
        high_keywords = self.keywords.get('high_priority', [])
        if high_keywords:
            rules.append(AlertRule(
                keywords=high_keywords,
                priority=AlertPriority.HIGH.value,
                enabled=True
            ))
        
        # Medium priority keywords
        medium_keywords = self.keywords.get('medium_priority', [])
        if medium_keywords:
            rules.append(AlertRule(
                keywords=medium_keywords,
                priority=AlertPriority.MEDIUM.value,
                enabled=True
            ))
        
        # Low priority keywords
        low_keywords = self.keywords.get('low_priority', [])
        if low_keywords:
            rules.append(AlertRule(
                keywords=low_keywords,
                priority=AlertPriority.LOW.value,
                enabled=True
            ))
        
        return rules

    def check_article(self, article) -> Optional[Alert]:
        """Check if article triggers any alerts"""
        if not self.enabled:
            return None
        
        # Combine title and content for matching
        text_to_check = f"{article.title} {article.content}"
        
        # Check each rule
        matched_keywords = []
        highest_priority = None
        
        for rule in self.rules:
            if rule.matches(text_to_check):
                # Find which keywords matched
                for keyword in rule.keywords:
                    if keyword.lower() in text_to_check.lower():
                        if keyword not in matched_keywords:
                            matched_keywords.append(keyword)
                
                # Track highest priority
                if highest_priority is None:
                    highest_priority = rule.priority
                else:
                    # Priority order: high > medium > low
                    priority_order = {
                        AlertPriority.HIGH.value: 3,
                        AlertPriority.MEDIUM.value: 2,
                        AlertPriority.LOW.value: 1
                    }
                    if priority_order.get(rule.priority, 0) > priority_order.get(highest_priority, 0):
                        highest_priority = rule.priority
        
        if matched_keywords:
            # Create alert
            alert = Alert(
                title=article.title,
                url=article.url,
                source=article.source,
                priority=highest_priority or AlertPriority.LOW.value,
                matched_keywords=matched_keywords,
                timestamp=datetime.now().isoformat(),
                content_preview=article.content[:200] + "..." if len(article.content) > 200 else article.content
            )
            
            self.alerts.append(alert)
            return alert
        
        return None

    def send_notifications(self, alert: Alert):
        """Send notifications through configured channels"""
        if not alert:
            return
        
        # Console notification
        if self.notification_channels.get('console', True):
            self._send_console_alert(alert)
        
        # File notification
        if self.notification_channels.get('file', True):
            self._save_file_alert(alert)
        
        # Email notification (if configured)
        if self.notification_channels.get('email', False):
            self._send_email_alert(alert)

    def _send_console_alert(self, alert: Alert):
        """Send alert to console"""
        priority_symbol = {
            AlertPriority.HIGH.value: "🔴",
            AlertPriority.MEDIUM.value: "🟡",
            AlertPriority.LOW.value: "🟢"
        }.get(alert.priority, "⚪")
        
        print("\n" + "=" * 80)
        print(f"{priority_symbol} ALERT [{alert.priority.upper()}]")
        print("=" * 80)
        print(f"標題: {alert.title}")
        print(f"來源: {alert.source}")
        print(f"關鍵字: {', '.join(alert.matched_keywords)}")
        print(f"URL: {alert.url}")
        print(f"時間: {alert.timestamp}")
        print(f"\n內容預覽:\n{alert.content_preview}")
        print("=" * 80 + "\n")

    def _save_file_alert(self, alert: Alert):
        """Save alert to file"""
        try:
            # Load existing alerts
            existing_alerts = []
            if os.path.exists(self.alert_file_path):
                try:
                    with open(self.alert_file_path, 'r', encoding='utf-8') as f:
                        data = json.load(f)
                        existing_alerts = data.get('alerts', [])
                except (json.JSONDecodeError, KeyError):
                    existing_alerts = []
            
            # Add new alert
            existing_alerts.append(asdict(alert))
            
            # Keep only last 1000 alerts
            if len(existing_alerts) > 1000:
                existing_alerts = existing_alerts[-1000:]
            
            # Save to file
            alert_data = {
                'last_updated': datetime.now().isoformat(),
                'total_alerts': len(existing_alerts),
                'alerts': existing_alerts
            }
            
            with open(self.alert_file_path, 'w', encoding='utf-8') as f:
                json.dump(alert_data, f, ensure_ascii=False, indent=2)
            
        except Exception as e:
            print(f"Error saving alert to file: {e}")

    def _send_email_alert(self, alert: Alert):
        """Send alert via email (requires email configuration)"""
        # This would integrate with email settings from config
        # For now, just log that email would be sent
        email_config = self.alert_config.get('email_settings', {})
        if not email_config.get('enabled', False):
            return
        
        # TODO: Implement email sending
        print(f"[EMAIL] Would send alert email for: {alert.title}")

    def get_alerts(self, priority: Optional[str] = None) -> List[Alert]:
        """Get alerts, optionally filtered by priority"""
        if priority:
            return [a for a in self.alerts if a.priority == priority]
        return self.alerts

    def get_alert_summary(self) -> Dict:
        """Get summary of alerts"""
        summary = {
            'total': len(self.alerts),
            'by_priority': {
                AlertPriority.HIGH.value: 0,
                AlertPriority.MEDIUM.value: 0,
                AlertPriority.LOW.value: 0
            },
            'by_source': {}
        }
        
        for alert in self.alerts:
            summary['by_priority'][alert.priority] = summary['by_priority'].get(alert.priority, 0) + 1
            summary['by_source'][alert.source] = summary['by_source'].get(alert.source, 0) + 1
        
        return summary

    def clear_alerts(self):
        """Clear alert history"""
        self.alerts.clear()


def main():
    """Test function"""
    config = {
        'alert_settings': {
            'enabled': True,
            'keywords': {
                'high_priority': ['台積電', 'TSMC'],
                'medium_priority': ['大盤', '指數'],
                'low_priority': ['財報']
            },
            'notification_channels': {
                'console': True,
                'file': True,
                'email': False
            }
        }
    }
    
    manager = AlertManager(config)
    
    # Test article
    from taiwan_news_crawler import NewsArticle
    
    test_article = NewsArticle(
        title="台積電宣布重大投資計劃",
        url="https://example.com/news1",
        content="台積電今日宣布將投資數百億美元擴建產能，預計將對大盤產生重大影響。",
        date="2024-01-01",
        source="test"
    )
    
    alert = manager.check_article(test_article)
    if alert:
        manager.send_notifications(alert)
        print(f"\nAlert Summary: {manager.get_alert_summary()}")


if __name__ == "__main__":
    main()

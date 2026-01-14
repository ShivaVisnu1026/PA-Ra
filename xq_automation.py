#!/usr/bin/env python3
"""
XQ Script Automation Tool
Automate daily tasks for managing XQ trading scripts
"""

import os
import shutil
from pathlib import Path
from datetime import datetime
import pandas as pd

class XQScriptManager:
    def __init__(self, workspace_path=None):
        """Initialize the XQ Script Manager"""
        if workspace_path:
            self.workspace = Path(workspace_path)
        else:
            self.workspace = Path.cwd()
        
        print(f"📂 Workspace: {self.workspace}")
        print("=" * 70)
    
    def backup_all_scripts(self):
        """Create timestamped backup of all .xs scripts"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_dir = self.workspace / "backups" / timestamp
        
        try:
            backup_dir.mkdir(parents=True, exist_ok=True)
            
            # Find all .xs files
            xs_files = list(self.workspace.glob("*.xs"))
            
            if not xs_files:
                print("⚠️  No .xs files found to backup")
                return
            
            # Copy each file
            for file in xs_files:
                shutil.copy2(file, backup_dir / file.name)
            
            print(f"✅ Backed up {len(xs_files)} scripts to:")
            print(f"   {backup_dir}")
            print()
            
            return backup_dir
            
        except Exception as e:
            print(f"❌ Backup failed: {e}")
            return None
    
    def list_scripts_by_category(self):
        """Organize and display scripts by timeframe and type"""
        xs_files = list(self.workspace.glob("pa_*.xs"))
        
        if not xs_files:
            print("⚠️  No pa_*.xs files found")
            return
        
        # Categorize scripts
        categories = {
            'Monthly': [],
            'Weekly': [],
            '60min': [],
            '15min': [],
            '5min': [],
            'Daily/Other': []
        }
        
        for file in xs_files:
            name = file.name
            if 'monthly' in name:
                categories['Monthly'].append(name)
            elif 'weekly' in name:
                categories['Weekly'].append(name)
            elif '60min' in name:
                categories['60min'].append(name)
            elif '15min' in name:
                categories['15min'].append(name)
            elif '5min' in name:
                categories['5min'].append(name)
            else:
                categories['Daily/Other'].append(name)
        
        # Display
        print("\n📊 XQ Scripts by Timeframe:")
        print("=" * 70)
        
        for category, files in categories.items():
            if files:
                print(f"\n🕒 {category}:")
                for f in sorted(files):
                    # Indicate bull/bear
                    icon = "🟢" if "bull" in f else "🔴" if "bear" in f else "⚪"
                    print(f"   {icon} {f}")
        
        print(f"\n📈 Total Scripts: {len(xs_files)}")
        print()
    
    def generate_script_report(self):
        """Generate detailed report of all scripts"""
        xs_files = list(self.workspace.glob("pa_*.xs"))
        
        if not xs_files:
            print("⚠️  No scripts found")
            return
        
        # Collect data
        data = []
        for file in xs_files:
            stat = file.stat()
            data.append({
                'File': file.name,
                'Size (KB)': round(stat.st_size / 1024, 2),
                'Modified': datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M'),
                'Type': 'Bull' if 'bull' in file.name else 'Bear' if 'bear' in file.name else 'Neutral',
                'Timeframe': self._extract_timeframe(file.name)
            })
        
        # Create DataFrame
        df = pd.DataFrame(data)
        df = df.sort_values(['Timeframe', 'Type', 'File'])
        
        print("\n📋 Detailed Script Report:")
        print("=" * 70)
        print(df.to_string(index=False))
        print()
        
        # Save to Excel
        report_file = self.workspace / f"script_report_{datetime.now().strftime('%Y%m%d')}.xlsx"
        df.to_excel(report_file, index=False, sheet_name='XQ Scripts')
        print(f"💾 Report saved to: {report_file.name}")
        print()
    
    def _extract_timeframe(self, filename):
        """Extract timeframe from filename"""
        if 'monthly' in filename:
            return '5-Monthly'
        elif 'weekly' in filename:
            return '4-Weekly'
        elif '60min' in filename:
            return '3-60min'
        elif '15min' in filename:
            return '2-15min'
        elif '5min' in filename:
            return '1-5min'
        else:
            return '6-Other'
    
    def count_lines_in_scripts(self):
        """Count total lines of code in all scripts"""
        xs_files = list(self.workspace.glob("*.xs"))
        
        if not xs_files:
            print("⚠️  No scripts found")
            return
        
        total_lines = 0
        script_stats = []
        
        for file in xs_files:
            with open(file, 'r', encoding='utf-8', errors='ignore') as f:
                lines = len(f.readlines())
                total_lines += lines
                script_stats.append((file.name, lines))
        
        print("\n📝 Code Statistics:")
        print("=" * 70)
        print(f"Total Scripts: {len(xs_files)}")
        print(f"Total Lines: {total_lines:,}")
        print(f"Average Lines per Script: {total_lines // len(xs_files):,}")
        print()
        
        # Top 5 largest scripts
        script_stats.sort(key=lambda x: x[1], reverse=True)
        print("🔝 Largest Scripts:")
        for name, lines in script_stats[:5]:
            print(f"   {name}: {lines} lines")
        print()
    
    def cleanup_old_backups(self, keep_days=7):
        """Remove backups older than specified days"""
        backup_dir = self.workspace / "backups"
        
        if not backup_dir.exists():
            print("⚠️  No backup directory found")
            return
        
        cutoff_date = datetime.now().timestamp() - (keep_days * 24 * 60 * 60)
        removed_count = 0
        
        for backup in backup_dir.iterdir():
            if backup.is_dir():
                if backup.stat().st_mtime < cutoff_date:
                    shutil.rmtree(backup)
                    removed_count += 1
                    print(f"🗑️  Removed old backup: {backup.name}")
        
        if removed_count == 0:
            print(f"✅ No backups older than {keep_days} days found")
        else:
            print(f"✅ Removed {removed_count} old backup(s)")
        print()


def main():
    """Main automation menu"""
    print("\n" + "="*70)
    print("🤖 XQ SCRIPT AUTOMATION TOOL")
    print("="*70)
    
    manager = XQScriptManager()
    
    while True:
        print("\n📋 Available Actions:")
        print("  1. 💾 Backup all scripts")
        print("  2. 📊 List scripts by timeframe")
        print("  3. 📋 Generate detailed report (Excel)")
        print("  4. 📝 Count lines of code")
        print("  5. 🗑️  Clean up old backups (>7 days)")
        print("  6. 🚀 Run all tasks")
        print("  0. ❌ Exit")
        
        choice = input("\n👉 Select option (0-6): ").strip()
        print()
        
        if choice == "1":
            manager.backup_all_scripts()
        elif choice == "2":
            manager.list_scripts_by_category()
        elif choice == "3":
            manager.generate_script_report()
        elif choice == "4":
            manager.count_lines_in_scripts()
        elif choice == "5":
            manager.cleanup_old_backups()
        elif choice == "6":
            print("🚀 Running all tasks...")
            print()
            manager.backup_all_scripts()
            manager.list_scripts_by_category()
            manager.count_lines_in_scripts()
            manager.generate_script_report()
            manager.cleanup_old_backups()
        elif choice == "0":
            print("👋 Goodbye!")
            break
        else:
            print("⚠️  Invalid option. Please try again.")
        
        input("\n⏸️  Press Enter to continue...")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 Automation stopped by user")
    except Exception as e:
        print(f"\n❌ Error: {e}")







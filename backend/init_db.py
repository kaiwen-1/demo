#!/usr/bin/env python3
"""
SQLite 数据库初始化脚本
使用 Python 执行 SQL 语句
"""
import sqlite3
import os

# 数据库文件路径
DB_FILE = 'db.sqlite3'
SQL_FILE = 'hotel_db_experiment.sql'

def main():
    print(f"开始初始化数据库: {DB_FILE}")
    print(f"读取 SQL 脚本: {SQL_FILE}")
    
    # 检查 SQL 文件是否存在
    if not os.path.exists(SQL_FILE):
        print(f"错误: SQL 文件 {SQL_FILE} 不存在")
        return 1
    
    # 读取 SQL 脚本
    try:
        with open(SQL_FILE, 'r', encoding='utf-8') as f:
            sql_script = f.read()
    except Exception as e:
        print(f"读取 SQL 文件失败: {e}")
        return 1
    
    # 连接数据库并执行脚本
    try:
        conn = sqlite3.connect(DB_FILE)
        cursor = conn.cursor()
        
        # 执行 SQL 脚本
        cursor.executescript(sql_script)
        conn.commit()
        
        print("\n数据库初始化成功！")
        print("\n执行结果:")
        
        # 检查数据插入情况
        tables = ['users', 'room_types', 'rooms', 'bookings', 'checkin_records', 'reviews']
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table}")
            count = cursor.fetchone()[0]
            print(f"{table}: {count} 条记录")
        
        # 查看用户密码（明文）
        print("\n用户信息（密码明文）:")
        cursor.execute("SELECT username, password, role FROM users")
        users = cursor.fetchall()
        for user in users:
            print(f"用户名: {user[0]}, 密码: {user[1]}, 角色: {user[2]}")
        
    except Exception as e:
        print(f"执行 SQL 失败: {e}")
        return 1
    finally:
        if 'conn' in locals():
            conn.close()
    
    return 0

if __name__ == '__main__':
    exit(main())
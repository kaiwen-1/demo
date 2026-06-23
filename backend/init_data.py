import os
import sys
import django

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from django.contrib.auth import get_user_model
from apps.rooms.models import RoomType, Room
from apps.bookings.models import Booking
from apps.reviews.models import Review
from apps.tags.models import Tag, RoomTypeTag
from apps.operations.models import Banner, Promotion, Coupon, UserCoupon
from datetime import date, timedelta, datetime

User = get_user_model()

def create_users():
    print('创建用户数据...')
    
    users_data = [
        {'username': 'admin', 'email': 'admin@hotel.com', 'password': 'admin123', 'role': 'admin', 'phone': '13800138000'},
        {'username': 'customer1', 'email': 'customer1@example.com', 'password': 'customer123', 'role': 'customer', 'phone': '13900139001'},
        {'username': 'customer2', 'email': 'customer2@example.com', 'password': 'customer123', 'role': 'customer', 'phone': '13900139002'},
        {'username': 'customer3', 'email': 'customer3@example.com', 'password': 'customer123', 'role': 'customer', 'phone': '13900139003'},
    ]
    
    for data in users_data:
        user, created = User.objects.get_or_create(
            username=data['username'],
            defaults={
                'email': data['email'],
                'role': data['role'],
                'phone': data['phone'],
            }
        )
        if created:
            user.set_password(data['password'])
            user.save()
            print(f'  创建用户: {user.username}')
    
    return User.objects.all()

def create_room_types():
    print('创建房型数据...')
    
    room_types_data = [
        {
            'name': '标准单人间',
            'description': '温馨舒适的标准单人间，配备1.2米单人床，适合商务出行人士。房间设施齐全，包括免费WiFi、空调、电视、独立卫浴等。',
            'price': 288,
            'capacity': 1,
            'size': 25,
            'amenities': ['免费WiFi', '空调', '液晶电视', '独立卫浴', '24小时热水', '吹风机', '洗漱用品']
        },
        {
            'name': '标准双人间',
            'description': '宽敞明亮的标准双人间，配备1.5米双人床，适合情侣或朋友出行。房间装修现代简约，设施完善。',
            'price': 388,
            'capacity': 2,
            'size': 35,
            'amenities': ['免费WiFi', '空调', '液晶电视', '独立卫浴', '24小时热水', '吹风机', '洗漱用品', '迷你吧']
        },
        {
            'name': '豪华大床房',
            'description': '豪华舒适的大床房，配备1.8米豪华大床，房间面积宽敞，装修典雅。配备高端设施，让您享受尊贵体验。',
            'price': 588,
            'capacity': 2,
            'size': 45,
            'amenities': ['免费WiFi', '中央空调', '智能电视', '独立卫浴', '浴缸', '24小时热水', '吹风机', '洗漱用品', '迷你吧', '保险箱', '办公桌椅']
        },
        {
            'name': '豪华套房',
            'description': '顶级豪华套房，独立客厅与卧室，配备2米超大床。房间面积达80平米，装修奢华，设施一流，是商务接待和家庭出游的理想选择。',
            'price': 1288,
            'capacity': 3,
            'size': 80,
            'amenities': ['免费WiFi', '中央空调', '智能电视', '独立卫浴', '浴缸', '淋浴间', '24小时热水', '吹风机', '洗漱用品', '迷你吧', '保险箱', '办公桌椅', '会客沙发', '茶几', '迷你厨房']
        },
        {
            'name': '家庭房',
            'description': '专为家庭设计的舒适房间，配备一张大床和一张单人床，可容纳3人入住。房间温馨舒适，适合亲子出游。',
            'price': 488,
            'capacity': 3,
            'size': 50,
            'amenities': ['免费WiFi', '空调', '液晶电视', '独立卫浴', '24小时热水', '吹风机', '洗漱用品', '儿童拖鞋', '儿童牙刷']
        },
        {
            'name': '商务套房',
            'description': '专为商务人士设计的套房，独立办公区域，配备高速网络和办公设备。舒适的大床让您在繁忙的工作后得到充分休息。',
            'price': 888,
            'capacity': 2,
            'size': 60,
            'amenities': ['免费WiFi', '中央空调', '智能电视', '独立卫浴', '浴缸', '24小时热水', '吹风机', '洗漱用品', '迷你吧', '保险箱', '办公桌椅', '打印机', '传真机']
        },
    ]
    
    for data in room_types_data:
        room_type, created = RoomType.objects.get_or_create(
            name=data['name'],
            defaults=data
        )
        if created:
            print(f'  创建房型: {room_type.name}')
    
    return RoomType.objects.all()

def create_rooms():
    print('创建房间数据...')
    
    room_types = {
        '标准单人间': RoomType.objects.get(name='标准单人间'),
        '标准双人间': RoomType.objects.get(name='标准双人间'),
        '豪华大床房': RoomType.objects.get(name='豪华大床房'),
        '豪华套房': RoomType.objects.get(name='豪华套房'),
        '家庭房': RoomType.objects.get(name='家庭房'),
        '商务套房': RoomType.objects.get(name='商务套房'),
    }
    
    rooms_data = [
        {'room_number': '101', 'floor': 1, 'room_type': '标准单人间', 'status': 'available'},
        {'room_number': '102', 'floor': 1, 'room_type': '标准单人间', 'status': 'available'},
        {'room_number': '103', 'floor': 1, 'room_type': '标准双人间', 'status': 'available'},
        {'room_number': '104', 'floor': 1, 'room_type': '标准双人间', 'status': 'occupied'},
        {'room_number': '201', 'floor': 2, 'room_type': '标准单人间', 'status': 'available'},
        {'room_number': '202', 'floor': 2, 'room_type': '标准双人间', 'status': 'available'},
        {'room_number': '203', 'floor': 2, 'room_type': '豪华大床房', 'status': 'available'},
        {'room_number': '204', 'floor': 2, 'room_type': '豪华大床房', 'status': 'available'},
        {'room_number': '301', 'floor': 3, 'room_type': '豪华大床房', 'status': 'available'},
        {'room_number': '302', 'floor': 3, 'room_type': '家庭房', 'status': 'available'},
        {'room_number': '303', 'floor': 3, 'room_type': '家庭房', 'status': 'available'},
        {'room_number': '304', 'floor': 3, 'room_type': '商务套房', 'status': 'available'},
        {'room_number': '401', 'floor': 4, 'room_type': '商务套房', 'status': 'available'},
        {'room_number': '402', 'floor': 4, 'room_type': '豪华套房', 'status': 'available'},
        {'room_number': '403', 'floor': 4, 'room_type': '豪华套房', 'status': 'available'},
        {'room_number': '501', 'floor': 5, 'room_type': '豪华套房', 'status': 'available'},
        {'room_number': '502', 'floor': 5, 'room_type': '豪华套房', 'status': 'maintenance'},
        {'room_number': '503', 'floor': 5, 'room_type': '豪华套房', 'status': 'available'},
    ]
    
    for data in rooms_data:
        room, created = Room.objects.get_or_create(
            room_number=data['room_number'],
            defaults={
                'floor': data['floor'],
                'room_type': room_types[data['room_type']],
                'status': data['status'],
            }
        )
        if created:
            print(f'  创建房间: {room.room_number} - {room.room_type.name}')
    
    return Room.objects.all()

def create_bookings():
    print('创建预订数据...')
    
    customer1 = User.objects.get(username='customer1')
    customer2 = User.objects.get(username='customer2')
    customer3 = User.objects.get(username='customer3')
    
    room1 = Room.objects.get(room_number='104')
    room2 = Room.objects.get(room_number='203')
    room3 = Room.objects.get(room_number='302')
    
    bookings_data = [
        {
            'user': customer1,
            'room': room1,
            'check_in_date': date.today(),
            'check_out_date': date.today() + timedelta(days=2),
            'guests': 2,
            'status': 'checked_in',
            'contact_name': '张三',
            'contact_phone': '13900139001',
        },
        {
            'user': customer2,
            'room': room2,
            'check_in_date': date.today() + timedelta(days=1),
            'check_out_date': date.today() + timedelta(days=3),
            'guests': 2,
            'status': 'confirmed',
            'contact_name': '李四',
            'contact_phone': '13900139002',
        },
        {
            'user': customer3,
            'room': room3,
            'check_in_date': date.today() + timedelta(days=5),
            'check_out_date': date.today() + timedelta(days=7),
            'guests': 3,
            'status': 'pending',
            'contact_name': '王五',
            'contact_phone': '13900139003',
        },
    ]
    
    for data in bookings_data:
        room = data['room']
        nights = (data['check_out_date'] - data['check_in_date']).days
        total_price = room.room_type.price * nights
        
        booking, created = Booking.objects.get_or_create(
            user=data['user'],
            room=data['room'],
            check_in_date=data['check_in_date'],
            defaults={
                'check_out_date': data['check_out_date'],
                'guests': data['guests'],
                'total_price': total_price,
                'status': data['status'],
                'contact_name': data['contact_name'],
                'contact_phone': data['contact_phone'],
            }
        )
        if created:
            print(f'  创建预订: {booking.user.username} - {booking.room.room_number}')
    
    return Booking.objects.all()

def create_reviews():
    print('创建评论数据...')
    
    customer1 = User.objects.get(username='customer1')
    customer2 = User.objects.get(username='customer2')
    customer3 = User.objects.get(username='customer3')
    
    room_type1 = RoomType.objects.get(name='豪华大床房')
    room_type2 = RoomType.objects.get(name='标准双人间')
    room_type3 = RoomType.objects.get(name='家庭房')
    
    reviews_data = [
        {
            'user': customer1,
            'room_type': room_type1,
            'rating': 5,
            'title': '非常满意的入住体验',
            'content': '房间非常干净整洁，设施齐全，床很舒适。前台服务态度很好，入住和退房都很顺利。早餐种类丰富，味道也不错。下次出差还会选择这里！',
        },
        {
            'user': customer2,
            'room_type': room_type2,
            'rating': 4,
            'title': '性价比不错的酒店',
            'content': '位置很好，交通便利。房间大小适中，卫生条件良好。唯一不足是隔音效果一般，晚上有点吵。总体来说性价比不错，推荐入住。',
        },
        {
            'user': customer3,
            'room_type': room_type3,
            'rating': 5,
            'title': '家庭出游首选',
            'content': '带孩子来玩，订的家庭房非常宽敞，孩子很喜欢。酒店还有儿童游乐区，非常贴心。服务人员也很热情，主动提供了儿童拖鞋和牙刷。强烈推荐给有孩子的家庭！',
        },
    ]
    
    for data in reviews_data:
        review, created = Review.objects.get_or_create(
            user=data['user'],
            room_type=data['room_type'],
            defaults={
                'rating': data['rating'],
                'title': data['title'],
                'content': data['content'],
            }
        )
        if created:
            print(f'  创建评论: {review.user.username} - {review.room_type.name}')
    
    return Review.objects.all()

def create_tags():
    print('创建标签数据...')
    
    tags_data = [
        {'name': '热门推荐', 'color': '#409EFF', 'description': '热门推荐房型', 'sort_order': 1},
        {'name': '限时优惠', 'color': '#67C23A', 'description': '限时优惠房型', 'sort_order': 2},
        {'name': '商务出行', 'color': '#E6A23C', 'description': '适合商务出行的房型', 'sort_order': 3},
        {'name': '家庭出游', 'color': '#F56C6C', 'description': '适合家庭出游的房型', 'sort_order': 4},
        {'name': '情侣度假', 'color': '#909399', 'description': '适合情侣度假的房型', 'sort_order': 5},
        {'name': '行政礼遇', 'color': '#722ED1', 'description': '行政礼遇房型', 'sort_order': 6},
    ]
    
    for data in tags_data:
        tag, created = Tag.objects.get_or_create(
            name=data['name'],
            defaults=data
        )
        if created:
            print(f'  创建标签: {tag.name}')
    
    # 为房型添加标签
    room_types = RoomType.objects.all()
    tags = Tag.objects.all()
    
    room_type_tags = [
        {'room_type': '豪华大床房', 'tags': ['热门推荐', '情侣度假', '行政礼遇']},
        {'room_type': '标准双人间', 'tags': ['限时优惠', '商务出行']},
        {'room_type': '家庭房', 'tags': ['家庭出游', '热门推荐']},
        {'room_type': '商务套房', 'tags': ['商务出行', '行政礼遇']},
        {'room_type': '豪华套房', 'tags': ['热门推荐', '行政礼遇', '情侣度假']},
    ]
    
    for item in room_type_tags:
        room_type = RoomType.objects.get(name=item['room_type'])
        for tag_name in item['tags']:
            tag = Tag.objects.get(name=tag_name)
            room_type_tag, created = RoomTypeTag.objects.get_or_create(
                room_type=room_type,
                tag=tag
            )
            if created:
                print(f'  为房型添加标签: {room_type.name} - {tag.name}')
    
    return Tag.objects.all()

def create_operations():
    print('创建运营管理数据...')
    
    # 创建轮播图
    banners_data = [
        {
            'title': '欢迎入住豪华酒店',
            'subtitle': '享受舒适的住宿体验',
            'link': '/rooms',
            'sort_order': 1,
            'is_active': True,
        },
        {
            'title': '商务出行首选',
            'subtitle': '专为商务人士设计的套房',
            'link': '/rooms?type=business',
            'sort_order': 2,
            'is_active': True,
        },
        {
            'title': '家庭出游特惠',
            'subtitle': '亲子度假的理想选择',
            'link': '/rooms?type=family',
            'sort_order': 3,
            'is_active': True,
        },
    ]
    
    for data in banners_data:
        banner, created = Banner.objects.get_or_create(
            title=data['title'],
            defaults=data
        )
        if created:
            print(f'  创建轮播图: {banner.title}')
    
    # 创建促销活动
    room_types = RoomType.objects.all()
    promotions_data = [
        {
            'title': '春季特惠',
            'description': '春季入住享受8折优惠',
            'discount_type': 'percentage',
            'discount_value': 20,
            'room_types': room_types[:3],  # 前3个房型
            'start_time': datetime.now() - timedelta(days=1),
            'end_time': datetime.now() + timedelta(days=30),
            'status': 'active',
            'sort_order': 1,
        },
        {
            'title': '周末特价',
            'description': '周末入住享受9折优惠',
            'discount_type': 'percentage',
            'discount_value': 10,
            'room_types': room_types,
            'start_time': datetime.now() - timedelta(days=1),
            'end_time': datetime.now() + timedelta(days=60),
            'status': 'active',
            'sort_order': 2,
        },
    ]
    
    for data in promotions_data:
        room_types_data = data.pop('room_types')
        promotion, created = Promotion.objects.get_or_create(
            title=data['title'],
            defaults=data
        )
        if created:
            promotion.room_types.set(room_types_data)
            print(f'  创建促销活动: {promotion.title}')
    
    # 创建优惠券
    coupons_data = [
        {
            'code': 'NEWYEAR2024',
            'name': '新年优惠',
            'coupon_type': 'fixed',
            'discount_value': 100,
            'min_amount': 500,
            'total_count': 100,
            'per_user_limit': 1,
            'start_time': datetime.now() - timedelta(days=1),
            'end_time': datetime.now() + timedelta(days=90),
            'is_active': True,
        },
        {
            'code': 'SUMMER2024',
            'name': '夏季特惠',
            'coupon_type': 'percentage',
            'discount_value': 15,
            'min_amount': 300,
            'max_discount': 200,
            'total_count': 200,
            'per_user_limit': 2,
            'start_time': datetime.now() - timedelta(days=1),
            'end_time': datetime.now() + timedelta(days=60),
            'is_active': True,
        },
    ]
    
    for data in coupons_data:
        coupon, created = Coupon.objects.get_or_create(
            code=data['code'],
            defaults=data
        )
        if created:
            print(f'  创建优惠券: {coupon.name} ({coupon.code})')
    
    # 为用户发放优惠券
    users = User.objects.filter(role='customer')
    coupons = Coupon.objects.all()
    
    for user in users:
        for coupon in coupons:
            user_coupon, created = UserCoupon.objects.get_or_create(
                user=user,
                coupon=coupon,
                defaults={'status': 'unused'}
            )
            if created:
                print(f'  为用户发放优惠券: {user.username} - {coupon.name}')
    
    return True

def main():
    print('=' * 50)
    print('开始初始化数据库...')
    print('=' * 50)
    
    create_users()
    create_room_types()
    create_rooms()
    create_bookings()
    create_reviews()
    create_tags()
    create_operations()
    
    print('=' * 50)
    print('数据库初始化完成！')
    print('=' * 50)
    print()
    print('管理员账号: admin / admin123')
    print('客户账号: user / user23')
    print()

if __name__ == '__main__':
    main()

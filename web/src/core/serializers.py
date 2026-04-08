from rest_framework import serializers
from .models import (
    User,
    Consumer,
    Supplier,
    SupplierStaff,
    ConsumerSupplierLink,
    ProductCategory,
    Product,
    Order,
    OrderItem,
    Complaint,
    ChatConversation,
    ChatMessage,
)
class UserSerializer(serializers.ModelSerializer):
    role = serializers.CharField(default="supplier", read_only=False)
    
    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "email",
            "first_name",
            "last_name",
            "role",
        ]
    
    def to_representation(self, instance):
        """Ensure role is always returned, default to supplier if null"""
        representation = super().to_representation(instance)
        if not representation.get('role') or representation['role'] is None:
            representation['role'] = 'supplier'
        return representation
class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True)
    re_password = serializers.CharField(write_only=True, required=True, label="Confirm Password")
    company_name = serializers.CharField(write_only=True, required=False, allow_blank=True)
    role = serializers.CharField(default="supplier", read_only=False)

    class Meta:
        model = User
        fields = [
            "username",
            "email",
            "password",
            "re_password",
            "first_name",
            "last_name",
            "role",
            "company_name",
        ]
        extra_kwargs = {
            "password": {"write_only": True},
            "role": {"default": "supplier"},
        }

    def validate(self, attrs):
        if attrs["password"] != attrs["re_password"]:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs

    def validate_role(self, value):
        """Always set role to supplier for registration"""
        return "supplier"
    
    def create(self, validated_data):
        validated_data.pop("re_password")
        password = validated_data.pop("password")
        company_name = validated_data.pop("company_name", "")
        validated_data["role"] = "supplier"
        user = User.objects.create(**validated_data)
        user.set_password(password)
        user.role = "supplier"
        user.save()

        user.refresh_from_db()

        from .models import Supplier, SupplierStaff
        from django.db import transaction
        
        try:

            with transaction.atomic():
                supplier_name = company_name or (validated_data.get("first_name", "") + " " + validated_data.get("last_name", "")).strip() or user.username
                if not supplier_name or supplier_name.strip() == "":
                    supplier_name = user.username
                
                supplier = Supplier.objects.create(
                    user=user,
                    name=supplier_name,
                    legal_name=company_name or supplier_name,
                    contact_email=validated_data.get("email", ""),
                )
                
                SupplierStaff.objects.create(
                    supplier=supplier,
                    user=user,
                    role="owner"
                )
        except Exception as e:

            import traceback
            traceback.print_exc()
            user.delete()
            raise serializers.ValidationError({
                "error": f"Failed to create supplier profile: {str(e)}"
            })

        user.refresh_from_db()

        return user

class ConsumerSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = Consumer
        fields = [
            "id",
            "user",
            "name",
            "legal_name",
            "address",
            "contact_email",
            "contact_phone",
            "birth_date",
            "is_active",
            "created_at",
        ]

class SupplierSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = Supplier
        fields = [
            "id",
            "user",
            "name",
            "legal_name",
            "address",
            "contact_email",
            "contact_phone",
            "is_active",
            "created_at",
        ]

class SupplierStaffSerializer(serializers.ModelSerializer):
    supplier = SupplierSerializer(read_only=True)
    user = UserSerializer(read_only=True)

    class Meta:
        model = SupplierStaff
        fields = [
            "id",
            "supplier",
            "user",
            "role",
        ]

class SupplierStaffWriteSerializer(serializers.ModelSerializer):
    username = serializers.CharField(write_only=True)
    email = serializers.EmailField(write_only=True)
    password = serializers.CharField(write_only=True)
    first_name = serializers.CharField(write_only=True, required=False, allow_blank=True)
    last_name = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = SupplierStaff
        fields = [
            "username",
            "email",
            "password",
            "first_name",
            "last_name",
            "role",
        ]

class ConsumerSupplierLinkSerializer(serializers.ModelSerializer):
    supplier = SupplierSerializer(read_only=True)
    consumer = ConsumerSerializer(read_only=True)

    class Meta:
        model = ConsumerSupplierLink
        fields = [
            "id",
            "supplier",
            "consumer",
            "status",
            "created_at",
            "updated_at",
        ]

class ProductCategorySerializer(serializers.ModelSerializer):
    supplier = SupplierSerializer(read_only=True)

    class Meta:
        model = ProductCategory
        fields = [
            "id",
            "name",
            "supplier",
        ]

class ProductSerializer(serializers.ModelSerializer):
    supplier = SupplierSerializer(read_only=True)
    category = ProductCategorySerializer(read_only=True)

    class Meta:
        model = Product
        fields = [
            "id",
            "supplier",
            "category",
            "sku",
            "name",
            "description",
            "unit",
            "price",
            "stock",
            "min_order_qty",
            "is_active",
            "updated_at",
        ]

class ProductWriteSerializer(serializers.ModelSerializer):
    supplier = serializers.PrimaryKeyRelatedField(read_only=True)
    
    class Meta:
        model = Product
        fields = [
            "supplier",
            "category",
            "sku",
            "name",
            "description",
            "unit",
            "price",
            "stock",
            "min_order_qty",
            "is_active",
        ]
        extra_kwargs = {
            'category': {'required': False, 'allow_null': True},
            'sku': {'required': False, 'allow_blank': True},
            'description': {'required': False, 'allow_blank': True},
        }

class OrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)

    class Meta:
        model = OrderItem
        fields = [
            "id",
            "product",
            "quantity",
            "unit_price",
            "line_total",
        ]

class OrderItemWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = [
            "product",
            "quantity",
            "unit_price",
            "line_total",
        ]

class OrderSerializer(serializers.ModelSerializer):
    consumer = ConsumerSerializer(read_only=True)
    supplier = SupplierSerializer(read_only=True)
    items = OrderItemSerializer(many=True, read_only=True)

    class Meta:
        model = Order
        fields = [
            "id",
            "consumer",
            "supplier",
            "status",
            "total",
            "note",
            "created_at",
            "updated_at",
            "items",
        ]

class OrderWriteSerializer(serializers.ModelSerializer):
    items = OrderItemWriteSerializer(many=True)

    class Meta:
        model = Order
        fields = [
            "consumer",
            "supplier",
            "status",
            "total",
            "note",
            "items",
        ]

    def create(self, validated_data):
        items_data = validated_data.pop("items")
        order = Order.objects.create(**validated_data)

        for item_data in items_data:
            OrderItem.objects.create(order=order, **item_data)

        return order

class ComplaintSerializer(serializers.ModelSerializer):
    order = OrderSerializer(read_only=True)

    class Meta:
        model = Complaint
        fields = [
            "id",
            "order",
            "raised_by_consumer",
            "description",
            "status",
            "created_at",
            "resolved_at",
        ]


class ComplaintWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Complaint
        fields = [
            "order",
            "raised_by_consumer",
            "description",
            "status",
        ]

class ChatMessageSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    user_id = serializers.PrimaryKeyRelatedField(source='user', queryset=User.objects.all(), write_only=True, required=False)

    class Meta:
        model = ChatMessage
        fields = [
            "id",
            "user",
            "user_id",
            "text",
            "created_at",
        ]
        read_only_fields = ["id", "user", "created_at"]


class ChatConversationSerializer(serializers.ModelSerializer):
    messages = ChatMessageSerializer(many=True, read_only=True)
    last_message = serializers.SerializerMethodField()

    class Meta:
        model = ChatConversation
        fields = [
            "id",
            "title",
            "messages",
            "last_message",
            "created_at",
            "updated_at",
        ]
        read_only_fields = ["id", "created_at", "updated_at"]

    def get_last_message(self, obj):
        last_msg = obj.messages.last()
        if last_msg:
            return {
                "text": last_msg.text,
                "created_at": last_msg.created_at
            }
        return None


class ChatConversationWriteSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatConversation
        fields = [
            "title",
        ]

from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    ROLE_CHOICES = [
        ("consumer", "Consumer"),
        ("supplier", "Supplier"),
        ("admin", "Admin"),
    ]

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default="supplier", null=False, blank=False)

    def __str__(self):
        return f"{self.username} ({self.role})"

class Consumer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="consumer_profile")
    name = models.CharField(max_length=255)
    legal_name = models.CharField(max_length=255, blank=True)
    address = models.TextField(blank=True)
    contact_email = models.EmailField(blank=True)
    contact_phone = models.CharField(max_length=20, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Supplier(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="supplier_profile")
    name = models.CharField(max_length=255)
    legal_name = models.CharField(max_length=255, blank=True)
    address = models.TextField(blank=True)
    contact_email = models.EmailField(blank=True)
    contact_phone = models.CharField(max_length=20, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class SupplierStaff(models.Model):
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="staff")
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="staff_profile")

    role = models.CharField(
        max_length=20,
        choices=[
            ("owner", "Owner"),
            ("manager", "Manager"),
            ("sales", "Sales"),
        ]
    )

class ConsumerSupplierLink(models.Model):
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="consumer_links")
    consumer = models.ForeignKey(Consumer, on_delete=models.CASCADE, related_name="supplier_links")

    status = models.CharField(
        max_length=20,
        choices=[
            ("pending", "Pending"),
            ("accepted", "Accepted"),
            ("blocked", "Blocked"),
            ("removed", "Removed"),
        ],
        default="pending"
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ("consumer", "supplier")

class ProductCategory(models.Model):
    name = models.CharField(max_length=128)
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="categories")

class Product(models.Model):
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="products")
    category = models.ForeignKey(ProductCategory, on_delete=models.SET_NULL, null=True, blank=True)
    sku = models.CharField(max_length=64, blank=True, null=True)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    unit = models.CharField(max_length=64, default="kg")
    price = models.DecimalField(max_digits=12, decimal_places=2)
    stock = models.IntegerField(default=0)
    min_order_qty = models.IntegerField(default=1)
    is_active = models.BooleanField(default=True)
    updated_at = models.DateTimeField(auto_now=True)

class Order(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("accepted", "Accepted"),
        ("rejected", "Rejected"),
        ("in_progress", "In Progress"),
        ("completed", "Completed"),
        ("cancelled", "Cancelled"),
    ]

    consumer = models.ForeignKey(Consumer, on_delete=models.CASCADE, related_name="orders")
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="orders")

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")
    total = models.DecimalField(max_digits=12, decimal_places=2, default=0)

    note = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.PROTECT)

    quantity = models.IntegerField()
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)
    line_total = models.DecimalField(max_digits=12, decimal_places=2)

class Complaint(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="complaints")

    raised_by_consumer = models.BooleanField(default=True)
    description = models.TextField()

    status = models.CharField(
        max_length=20,
        choices=[
            ("open", "Open"),
            ("in_progress", "In Progress"),
            ("resolved", "Resolved"),
        ],
        default="open"
    )

    created_at = models.DateTimeField(auto_now_add=True)
    resolved_at = models.DateTimeField(null=True, blank=True)


class ChatConversation(models.Model):
    """Represents a chat conversation thread"""
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name="conversations")
    title = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} ({self.supplier.name})"


class ChatMessage(models.Model):
    """Individual chat messages within a conversation"""
    conversation = models.ForeignKey(ChatConversation, on_delete=models.CASCADE, related_name="messages")
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="chat_messages")
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f"{self.user.username}: {self.text[:50]}"

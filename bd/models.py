from django.db import models
from django.core.validators import EmailValidator

# дополнительный интерфейс между БД (сервером) иджанго . переводчик sql  / функционал - родитель 


class Insurance(models.Model):
    INSURANCE_CHOICES = (
        (0, 'Тип 0'),
        (1, 'Тип 1'),
    )
    insurance_type = models.IntegerField(choices=INSURANCE_CHOICES)
    
    def __str__(self):
        return f"Страховка типа {self.get_insurance_type_display()}"


class Airlines(models.Model):
    name_airline = models.CharField(max_length=200)
    
    def __str__(self):
        return self.name_airline


class Flights(models.Model):
    airlines = models.ForeignKey(Airlines, on_delete=models.CASCADE)
    flight_number = models.CharField(max_length=50)
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()
    
    def __str__(self):
        return f"{self.flight_number} ({self.airlines.name_airline})"


class Countries(models.Model):
    name_country = models.CharField(max_length=100)
    
    def __str__(self):
        return self.name_country


class Cities(models.Model):
    name_city = models.CharField(max_length=100)
    countries = models.ForeignKey(Countries, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"{self.name_city}, {self.countries.name_country}"


class Hotels(models.Model):
    name_hotel = models.CharField(max_length=200)
    child_menu = models.BooleanField(default=False)
    have_nanny = models.BooleanField(default=False)
    child_program = models.BooleanField(default=False)
    cities = models.ForeignKey(Cities, on_delete=models.CASCADE)
    hotel_address = models.TextField()
    geo_coordinates = models.CharField(max_length=100, null=True, blank=True)
    
    def __str__(self):
        return self.name_hotel


class Organizations(models.Model):
    name_organization = models.CharField(max_length=200)
    
    def __str__(self):
        return self.name_organization


class Tours(models.Model):
    name_tour = models.CharField(max_length=200)
    insurance = models.ForeignKey(Insurance, on_delete=models.CASCADE)
    flights = models.ForeignKey(Flights, on_delete=models.CASCADE)
    cities = models.ForeignKey(Cities, on_delete=models.CASCADE)
    hotels = models.ForeignKey(Hotels, on_delete=models.CASCADE)
    mark_for_deletion = models.BooleanField(null=True)
    
    def __str__(self):
        return self.name_tour


class Excursions(models.Model):
    name_excursion = models.CharField(max_length=200)
    night_transfer = models.BooleanField(default=False)
    danger_level = models.IntegerField(default=0)
    child_friendly = models.BooleanField(default=False)
    duration = models.IntegerField()
    cities = models.ForeignKey(Cities, on_delete=models.CASCADE)
    organizations = models.ForeignKey(Organizations, on_delete=models.CASCADE)
    tours = models.ForeignKey(Tours, on_delete=models.SET_NULL, null=True, blank=True)
    
    def __str__(self):
        return self.name_excursion


class Managers(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    phone = models.CharField(max_length=20)
    email = models.EmailField(validators=[EmailValidator()])
    
    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class Clients(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    patronymic = models.CharField(max_length=100, null=True, blank=True)
    phone = models.CharField(max_length=20)
    email = models.EmailField(validators=[EmailValidator()])
    passport_number = models.CharField(max_length=50)
    mark_for_deletion = models.BooleanField(null=True)
    not_active = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.last_name} {self.first_name}"


class ClientCities(models.Model):
    name_client_city = models.CharField(max_length=100)
    clients = models.ForeignKey(Clients, on_delete=models.CASCADE, null=True)
    
    def __str__(self):
        return self.name_client_city


class Contracts(models.Model):
    contract_number = models.CharField(max_length=50, unique=True)
    clients = models.ForeignKey(Clients, on_delete=models.CASCADE)
    managers = models.ForeignKey(Managers, on_delete=models.CASCADE)
    tours = models.ForeignKey(Tours, on_delete=models.CASCADE)
    
    def __str__(self):
        return self.contract_number


class PaymentMethods(models.Model):
    method_name = models.CharField(max_length=100, unique=True)
    
    def __str__(self):
        return self.method_name


class PaymentStatuses(models.Model):
    status_name = models.CharField(max_length=100, unique=True)
    
    def __str__(self):
        return self.status_name


class Payments(models.Model):
    contracts = models.ForeignKey(Contracts, on_delete=models.CASCADE)
    payment_date = models.DateTimeField()
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.ForeignKey(PaymentStatuses, on_delete=models.CASCADE)
    payment_method = models.ForeignKey(PaymentMethods, on_delete=models.CASCADE)
    
    def __str__(self):
        return f"Платеж {self.amount} по контракту {self.contracts.contract_number}"


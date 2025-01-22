from django.core.management.base import BaseCommand
import sqlite3
from bd.models import *
from django.db import transaction

class Command(BaseCommand):
    help = 'Импорт данных из SQL файла'

    def handle(self, *args, **options):
        try:
            with transaction.atomic():
                with open('your_sql_file.sql', 'r', encoding='utf-8') as sql_file:
                    # Читаем SQL-файл и выполняем команды
                    sql_commands = sql_file.read().split(';')
                    
                    conn = sqlite3.connect(':memory:')  # Временная БД в памяти
                    cursor = conn.cursor()
                    
                    # Выполняем команды создания таблиц и вставки данных
                    for command in sql_commands:
                        if command.strip():
                            cursor.execute(command)
                
                # Подключение к вашей существующей базе данных
                conn = sqlite3.connect('your_existing_database.db')  # укажите путь к вашей БД
                cursor = conn.cursor()

                # Импорт Insurance
                cursor.execute('SELECT * FROM Insurance')
                for row in cursor.fetchall():
                    Insurance.objects.create(
                        id=row[0],
                        insurance_type=row[1]
                    )
                self.stdout.write('Импортированы данные Insurance')

                # Импорт Airlines
                cursor.execute('SELECT * FROM Airlines')
                for row in cursor.fetchall():
                    Airlines.objects.create(
                        id=row[0],
                        name_airline=row[1]
                    )
                self.stdout.write('Импортированы данные Airlines')

                # Импорт Countries
                cursor.execute('SELECT * FROM Countries')
                for row in cursor.fetchall():
                    Countries.objects.create(
                        id=row[0],
                        name_country=row[1]
                    )
                self.stdout.write('Импортированы данные Countries')

                # Импорт Cities
                cursor.execute('SELECT * FROM Cities')
                for row in cursor.fetchall():
                    Cities.objects.create(
                        id=row[0],
                        name_city=row[1],
                        countries_id=row[2]
                    )
                self.stdout.write('Импортированы данные Cities')

                # Импорт Hotels
                cursor.execute('SELECT * FROM Hotels')
                for row in cursor.fetchall():
                    Hotels.objects.create(
                        id=row[0],
                        name_hotel=row[1],
                        child_menu=bool(row[2]),
                        have_nanny=bool(row[3]),
                        child_program=bool(row[4]),
                        cities_id=row[5],
                        hotel_address=row[6],
                        geo_coordinates=row[7] if row[7] else None
                    )
                self.stdout.write('Импортированы данные Hotels')

                # Продолжайте для остальных таблиц...

                conn.close()
                self.stdout.write(self.style.SUCCESS('Данные успешно импортированы'))

        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Ошибка при импорте: {str(e)}')) 
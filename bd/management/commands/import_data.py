from django.core.management.base import BaseCommand
from django.db import connection


class Command(BaseCommand):
    help = 'Импорт данных из SQL файла'

    def handle(self, *args, **options):
        


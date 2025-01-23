from django.conf import settings
from django.core.management.base import BaseCommand
from django.db import connection

from pathlib import Path


class Command(BaseCommand):
    help = 'чтение SQL скрипта из файла и выполнение INSERT запросов'
    
    def add_arguments(self, parser):
        parser.add_argument('sql_script_path', type=Path)
    
    def handle(self, *args, **options):
        sql_script_path = settings.BASE_DIR / options['sql_script_path']
        


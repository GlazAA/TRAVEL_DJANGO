from django.conf import settings
from django.core.management.base import BaseCommand
from django.db import connection

from pathlib import Path
from re import compile

class Command(BaseCommand):
    help = 'чтение SQL скрипта из файла и выполнение INSERT запросов'
    pat_query_sep = compile(r';\n*')
    
    def add_arguments(self, parser):
        parser.add_argument('sql_script_path', type=Path)
    
    def handle(self, *args, **options):
        sql_script_path = settings.BASE_DIR / options['sql_script_path']
        sql_script = sql_script_path.read_text(encoding='utf-8')
        
        querries = self.pat_query_sep.split(sql_script)
        try:
            querries.remove('')
        except ValueError:
            pass
        


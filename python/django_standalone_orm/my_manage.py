# coding: utf-8
from django.conf import settings

db_conf = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'your_database_name',
        'USER': 'your_user_name',
        'PASSWORD': 'your_password',
        'HOST': 'your_mysql_server_host',
        'PORT': 'your_mysql_server_port',
    }
}

settings.configure(
    DATABASES = db_conf,
    INSTALLED_APPS     = ( "myApp", )
)

# Calling django.setup() is required for “standalone” Django u usage
# https://docs.djangoproject.com/en/1.8/topics/settings/#calling-django-setup-is-required-for-standalone-django-usage
import django
django.setup()

if __name__ == '__main__':
    import sys
    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)

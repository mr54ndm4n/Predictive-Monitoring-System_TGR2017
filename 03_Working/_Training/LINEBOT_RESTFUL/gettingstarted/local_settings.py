import os

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'db3rri358drm0f',
        'USER': 'jufpynxgbrliat',
        'PASSWORD': '76eb685ca9f1b82253ab683ceb82aec5487a0db5176b56ba978516333a939b98',
        'HOST': 'ec2-54-235-240-92.compute-1.amazonaws.com',
        'PORT': '5432',
    }
}
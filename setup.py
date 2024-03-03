from setuptools import setup

setup(
    name='mac',
    version='0.1.0',
    py_modules=['mac'],
    install_requires=[
        'Click',
        'netaddr',
        'psutil',
    ],
    entry_points={
        'console_scripts': [
            'mac = mac:mac',
        ],
    },
)
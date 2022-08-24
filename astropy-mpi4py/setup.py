from setuptools import setup, find_packages

setup(
    author="R. C. Thomas",
    author_email="rcthomas@lbl.gov",
    description="AstroPy + mpi4py launch time benchmark",
    name="astropyle",
    version="0.3.0",
    packages=find_packages(exclude=["tests"]),
)

from setuptools import find_packages, setup

setup(
    name="flazk",
    version="1.0.0",
    include_package_data=True,
    zip_false=False,
    install_requires=["flask", "beautifulsoup4"],
    extras_require={"dev": ["pylint", "black", "pytest", "coverage"]},
)

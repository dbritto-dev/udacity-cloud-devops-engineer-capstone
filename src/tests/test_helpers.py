# Built-in Package
from datetime import datetime

# 3rd Party Packages
from pytest import mark

# Local Packages
from app import helpers


@mark.parametrize("empty_case", [(None, "none"), ("", "")])
def test_slugify_empty_cases(empty_case):
    value, expected_output = empty_case
    assert helpers.slugify(value) == expected_output


@mark.parametrize(
    "valid_case",
    [
        ("Hello, World!", "hello-world", False),
        ("spam & eggs", "spam-eggs", False),
        ("spam & ıçüş", "spam-ıçüş", True),
        ("foo ıç bar", "foo-ıç-bar", True),
        ("    foo ıç bar", "foo-ıç-bar", True),
        ("你好", "你好", True),
        ("İstanbul", "istanbul", True),
    ],
)
def test_slugify_valid_cases(valid_case):
    value, expected_output, is_unicode = valid_case
    assert helpers.slugify(value, is_unicode) == expected_output


@mark.parametrize(
    "valid_case",
    [
        ("0", 0),
        ("123", 123),
        ("1,234", 1234),
        ("1,234,567", 1234567),
        ("1,234,567,890", 1234567890),
        ("---", None),
    ],
)
def test_string_to_integer_valid_cases(valid_case):
    value, expected_output = valid_case
    assert helpers.string_to_integer(value) == expected_output


@mark.parametrize(
    "valid_case",
    [
        ("23 April 2020, at 23:09 UTC", datetime(2020, 4, 23, 23, 9)),
        ("23 April 2020, at 23:39 UTC", datetime(2020, 4, 23, 23, 39)),
    ],
)
def test_parse_date_valid_cases(valid_case):
    value, expected_ouput = valid_case
    assert helpers.parse_date(value) == expected_ouput

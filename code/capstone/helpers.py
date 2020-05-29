# Built-in Packages
from re import sub
from unicodedata import normalize
from datetime import datetime

# Types
from typing import Optional


# Take it from https://github.com/django/django/blob/master/django/utils/text.py#L394
def slugify(value: str, allow_unicode: bool = False) -> str:
    """
    Convert to ASCII if 'allow_unicode' is False. Convert spaces to hyphens.
    Remove characters that aren't alphanumerics, underscores, or hyphens.
    Convert to lowercase. Also strip leading and trailing whitespace.
    """
    value = str(value)
    if allow_unicode:
        value = normalize("NFKC", value)
    else:
        value = normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = sub(r"[^\w\s-]", "", value.lower()).strip()
    return sub(r"[-\s]+", "-", value)


def string_to_integer(string: str) -> Optional[int]:
    """
    Convert string numbers to integer.
    i.e: string_to_integer('12,000') -> 12000
    """
    try:
        return int(sub(r"[^0-9\.]", "", string))
    except ValueError:
        return None


def parse_date(string: str) -> datetime:
    """
    Convert string dates to datetime
    i.e: parse_date('23 April 2020, at 17:00') -> datetime(2020, 04, 23, 17, 0)
    """
    return datetime.strptime(string, "%d %B %Y, at %H:%M %Z")

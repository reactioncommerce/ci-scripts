#!/usr/bin/env python3

# This script takes CamelCase parameter names on the command line,
# Looks up the corresponding UPPER_SNAKE_CASE environment variable,
# and outputs parameter override syntax

# Proper bash shell escaping is done.

# It can print out in 2 syntaxes
# 1. cloudformation SomeKey=SomeValue AnotherKey=AnotherValue
# 2. sam ParameterKey=SomeKey,ParameterValue=SomeValue ParameterKey=AnotherKey,ParameterValue=AnotherValue

# Pass --sam as the first command line argument to get sam output syntax.
# cloudformation syntax is the default

import os
import re
import shlex
import sys

# https://stackoverflow.com/a/1176023/266795
def camel_to_snake(name):
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).upper()


sam = False
for camel_name in sys.argv[1:]:
    if camel_name == "--sam":
        sam = True
        continue
    env_name = camel_to_snake(camel_name)
    env = shlex.quote(os.environ.get(env_name, ""))
    if sam:
        print(f"ParameterKey={camel_name}", f"ParameterValue={env}", sep=",", end=" ")
    else:
        print(camel_name, env, sep="=", end=" ")

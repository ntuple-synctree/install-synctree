#!/bin/bash
(crontab -l 2>/dev/null; echo "4 0 * * * curl --location --request POST 'localhost/batch/log/proxy' > /dev/null 2>&1") | crontab -

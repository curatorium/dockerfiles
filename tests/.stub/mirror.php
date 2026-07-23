<?php

file_put_contents('/tmp/'.$argv[1].'.out', $argv[1]."\n", FILE_APPEND);

while (true)
    sleep(1);

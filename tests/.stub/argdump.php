<?php

// Records every arg after the service name so tests can assert glob-safety.
file_put_contents('/tmp/'.$argv[1].'.args', implode(' ', array_slice($argv, 2)));

while (true)
    sleep(1);

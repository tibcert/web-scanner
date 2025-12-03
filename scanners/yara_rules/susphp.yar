rule Suspicious_PHP_File {
    meta:
        author = "ngo-security"
        description = "Detect suspicious 'eval' in PHP files (noise rule)"
    strings:
        $s1 = "eval("
        $s2 = "base64_decode("
    condition:
        uint16(0) == 0x3c3f and any of them
}

#!/usr/bin/python2
import os
import yaml
import datetime
from subprocess import Popen, PIPE
from OpenSSL import crypto as c

config_file = "/etc/letsencrypt/config.yml"

class FileNotFoundError(IOError):
    """ File not found exception

    Args:
        message (str): Message passed with the exception

    """
    def __init__(self, message):
        super(FileNotFoundError, self).__init__("File not found: {0}".format(message))

class MalformedConfig(Exception):
    """ Malformed configuration exception

    Args:
        message (str): Message passed with the exception

    """
    def __init__(self, message):
        super(MalformedConfig, self).__init__("Config is malformed: {0}".format(message))


# parse config fileg
if not os.path.exists(config_file):
    raise FileNotFoundError("Configuration file: {0}".format(config_file))

with open(config_file, 'r') as f:
    file_content = f.read()

try:
    config = yaml.load(file_content)
except yaml.YAMLError, e:
    if hasattr(e, 'problem_mark'):
        mark = e.problem_mark
        raise yaml.YAMLError("YAML syntax error in config file at line {0} column {1}".format(mark.line+1, mark.column+1))
    else:
        raise yaml.YAMLError("YAML syntax error in config: {0}".format(e.message))

# get global params and set defaults
defaults = {
    'rsa_key_size': 4096,
    'days_before_expiry': 30,
    'email': None
    }
for d in defaults.keys():
    if config.has_key(d):
        defaults[d] = config[d]

# iterate through 'obtain_certificates_for'
if not config.has_key("obtain_certificates_for"):
    raise MalformedConfig("Key 'obtain_certificates_for' missing")

created_or_renewed_cert = False
for ocf in config['obtain_certificates_for']:
    if not ocf.has_key("domains"):
        raise MalformedConfig("Key 'domains' missing")

    for d in defaults:
        if ocf.has_key(d):
            locals()[d] = ocf[d]
        else:
            locals()[d] = defaults[d]

    if email is None:
        raise MalformedConfig("Key 'email' missing")

    for domain in ocf["domains"]:
        if os.path.exists("/etc/letsencrypt/live/{0}/cert.pem".format(domain)):
            # check expiry date
            cert = c.load_certificate(c.FILETYPE_PEM, file("/etc/letsencrypt/live/{0}/cert.pem".format(domain)).read())
            cert_expiry_date = datetime.datetime.strptime(cert.get_notAfter(),"%Y%m%d%H%M%SZ")
            days_left = (cert_expiry_date - (datetime.datetime.now() + datetime.timedelta(days=days_before_expiry))).days
            if days_left < days_before_expiry:
                p = Popen(["certbot", "certonly", "--webroot", "--non-interactive", "--renew-by-default", "--agree-tos", "-w", "/var/www/letsencrypt-challenge-response", "--rsa-key-size", str(rsa_key_size), "--email", str(email), "-d", str(domain)], stderr=PIPE, universal_newlines=True)
                p.wait()
                if p.returncode == 0:
                    created_or_renewed_cert = True
                    print("Successfully renewed certificate for: {0}".format(domain))
                    # run post hook
                    if os.path.exists("/etc/letsencrypt/letsencrypt_post_create_hook.sh"):
                        p = Popen(["bash", "/etc/letsencrypt/letsencrypt_post_create_hook.sh", str(domain)], stderr=PIPE, universal_newlines=True)
                        p.wait()
                else:
                    print("Failed to renew certificate for: {0}".format(domain))
        else:
            p = Popen(["certbot", "certonly", "--webroot", "--non-interactive", "--agree-tos", "-w", "/var/www/letsencrypt-challenge-response", "--rsa-key-size", str(rsa_key_size), "--email", str(email), "-d", str(domain)], stderr=PIPE, universal_newlines=True)
            p.wait()
            if p.returncode == 0:
                created_or_renewed_cert = True
                print("Successfully created certificate for: {0}".format(domain))
                # run post hook
                if os.path.exists("/etc/letsencrypt/letsencrypt_post_create_hook.sh"):
                    p = Popen(["bash", "/etc/letsencrypt/letsencrypt_post_create_hook.sh", str(domain)], stderr=PIPE, universal_newlines=True)
                    p.wait()
            else:
                print("Failed to create certificate for: {0}".format(domain))

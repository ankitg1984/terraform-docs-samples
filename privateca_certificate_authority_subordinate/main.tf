# [START privateca_create_subordinateca]
resource "google_privateca_certificate_authority" "root-ca" {
  pool = "my-pool"
  certificate_authority_id = "my-certificate-authority-root"
  location = "us-central1"
  deletion_protection = false # set to true to prevent destruction of the resource
  ignore_active_certificates_on_deletion = true
  config {
    subject_config {
      subject {
        organization = "HashiCorp"
        common_name = "my-certificate-authority"
      }
      subject_alt_name {
        dns_names = ["hashicorp.com"]
      }
    }
    x509_config {
      ca_options {
        # is_ca *MUST* be true for certificate authorities
        is_ca = true
      }
      key_usage {
        base_key_usage {
          # cert_sign and crl_sign *MUST* be true for certificate authorities
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = false
        }
      }
    }
  }
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
}

resource "google_privateca_certificate_authority" "default" {
  // This example assumes this pool already exists.
  // Pools cannot be deleted in normal test circumstances, so we depend on static pools
  pool = "my-pool"
  certificate_authority_id = "my-certificate-authority-sub"
  location = "us-central1"
  deletion_protection = false # set to true to prevent destruction of the resource
  subordinate_config {
    certificate_authority = google_privateca_certificate_authority.root-ca.name
  }
  config {
    subject_config {
      subject {
        organization = "HashiCorp"
        common_name = "my-subordinate-authority"
      }
      subject_alt_name {
        dns_names = ["hashicorp.com"]
      }
    }
    x509_config {
      ca_options {
        is_ca = true
        # Force the sub CA to only issue leaf certs
        max_issuer_path_length = 0
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          content_commitment = true
          key_encipherment = false
          data_encipherment = true
          key_agreement = true
          cert_sign = true
          crl_sign = true
          decipher_only = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = false
          email_protection = true
          code_signing = true
          time_stamping = true
        }
      }
    }
  }
  lifetime = "86400s"
  key_spec {
    algorithm = "RSA_PKCS1_4096_SHA256"
  }
  type = "SUBORDINATE"
}
# [END privateca_create_subordinateca]

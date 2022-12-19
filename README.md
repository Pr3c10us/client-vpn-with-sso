### Deploy vpn client endpoint on aws using terraform

-   Steps
    <pre>
     - clone the repo.
     - cd to certs dir and run certs.sh script
        this script generates all the certificates needed.
     - configure aws to obtain credentials.
     - Enable aws IAM Identity Center.
     - Create new sso application
     - Download the metadata.xml file and rename it to saml-metadata.xml
      - copy the saml-metadata.xml file to the certs dir.
      - run terraform init
     - run terraform plan
     - run terraform apply

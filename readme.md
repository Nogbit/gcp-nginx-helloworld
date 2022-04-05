# GCP Starter Project

This repo gets you up and running in GCP.

- Creates a minimal network and subnet
- Creates a Cloud NAT for egress to the internet
- Creates two small VM's to test HTTP requests

## Setup

1. Create a GCP Project

    1. While it's possible to Terraform the project itself, the attachment of the billing account doesn't propagate in time and results in a mess of null resource dependencies and sleeping...

    1. ...with that said, create a new GCP Project using the web console

    1. Make sure you set the billing account and folder

1. Install the `gcloud` CLI

1. Install Terraform

1. **Clone this repo**

1. Initialize `terraform init`

1. Login using the CLI `gcloud auth application-default login`.  Alternatively you can [authenticate as a service account](https://cloud.google.com/docs/authentication/production).

## Create the Infrastructure

This will deploy all the resources in `main.tf`.

1. Edit `terraform.tfvars` to include your project id and desired settings.

1. Deploy your infrastructure

       terraform plan
       terraform apply

1. SSH to the consumer instance using IAP tunneling

       gcloud compute ssh nginx-consumer

1. Make a request to the Nginx web server, you should see some HTML as a result that has `Thank you for using nginx` in it.

       curl nginx

       exit

1. You can now SSH to the Nginx web server and edit configs as needed.

        gcloud compute ssh nginx

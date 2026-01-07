terraform {
    backend "gcs" {
        bucket = "g4-insset-projet-2025-tfstate"
        prefix = "terraform/state"
    }
}
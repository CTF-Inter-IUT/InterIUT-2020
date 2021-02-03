output "access_token" {
    value = "3ea5f9040670fbe2d4395de691a3055d48c415fc79476c7a8c2e0aad2b916706"
    sensitive = true
    depends_on = [docker_container.ctfd]
}

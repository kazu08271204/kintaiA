# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "上長A",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password")

User.create!(name: "上長B",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password")
             
User.create!(name: "テストA",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password")
             
User.create!(name: "テストB",
             email: "sample-4@email.com",
             password: "password",
             password_confirmation: "password")
             
             


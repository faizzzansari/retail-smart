# 🛒 RetailSmart — Inventory & Billing System

RetailSmart is a full-stack inventory and billing application designed to help manage products, inventory, and billing operations through a mobile application.

The project consists of a **Python FastAPI backend** that provides RESTful APIs and a **Flutter mobile application** that provides the user interface.

---

## 📌 Project Overview

RetailSmart provides a simple system for managing retail inventory and billing operations.

The application follows a client-server architecture:

```text
┌─────────────────────────────┐
│       Flutter App           │
│        Mobile UI             │
│        Dart / Flutter        │
└──────────────┬──────────────┘
               │
               │ REST API
               ▼
┌─────────────────────────────┐
│      FastAPI Backend        │
│       Python / FastAPI       │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│          Database            │
│     Application Data         │
└─────────────────────────────┘

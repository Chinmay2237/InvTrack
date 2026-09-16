import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Centralized iOS SF-Inspired Icon System for InvTrack.
/// Houses all semantic icon definitions across the application with balanced
/// optical proportions, 2.0 stroke thickness, and rounded terminals.
abstract final class AppIcons {
  // --- Primary Navigation ---
  static const IconData dashboard = LucideIcons.layout_dashboard;
  static const IconData dashboardActive = LucideIcons.layout_dashboard;
  static const IconData inventory = LucideIcons.box;
  static const IconData inventoryActive = LucideIcons.boxes;
  static const IconData scan = LucideIcons.scan_line;
  static const IconData scanActive = LucideIcons.qr_code;
  static const IconData handovers = LucideIcons.arrow_left_right;
  static const IconData handoversActive = LucideIcons.user_check;
  static const IconData settings = LucideIcons.settings;
  static const IconData settingsActive = LucideIcons.sliders_horizontal;

  // --- Inventory & Assets ---
  static const IconData asset = LucideIcons.box;
  static const IconData assetGroup = LucideIcons.layers;
  static const IconData serialNumber = LucideIcons.barcode;
  static const IconData category = LucideIcons.grid_2x2;
  static const IconData stock = LucideIcons.archive;
  static const IconData available = LucideIcons.circle_check;
  static const IconData lowStock = LucideIcons.triangle_alert;
  static const IconData unavailable = LucideIcons.circle_x;
  static const IconData warehouse = LucideIcons.warehouse;
  static const IconData batchNumber = LucideIcons.tag;
  static const IconData expiryDate = LucideIcons.calendar;

  // --- Actions ---
  static const IconData add = LucideIcons.plus;
  static const IconData edit = LucideIcons.pencil;
  static const IconData delete = LucideIcons.trash;
  static const IconData archive = LucideIcons.archive;
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.sliders_horizontal;
  static const IconData sort = LucideIcons.arrow_up_down;
  static const IconData refresh = LucideIcons.refresh_cw;
  static const IconData more = LucideIcons.ellipsis;
  static const IconData close = LucideIcons.x;
  static const IconData back = LucideIcons.chevron_left;
  static const IconData forward = LucideIcons.chevron_right;
  static const IconData download = LucideIcons.download;
  static const IconData exportCsv = LucideIcons.file_spreadsheet;
  static const IconData exportPdf = LucideIcons.file_text;
  static const IconData scanBarcode = LucideIcons.barcode;
  static const IconData flashOn = LucideIcons.zap;
  static const IconData flashOff = LucideIcons.zap_off;

  // --- Operations & Workflow ---
  static const IconData supplier = LucideIcons.truck;
  static const IconData purchaseOrder = LucideIcons.file_check;
  static const IconData assignment = LucideIcons.user_check;
  static const IconData returnAsset = LucideIcons.rotate_ccw;
  static const IconData history = LucideIcons.clock;
  static const IconData location = LucideIcons.map_pin;
  static const IconData calendar = LucideIcons.calendar;
  static const IconData attachment = LucideIcons.paperclip;
  static const IconData maintenance = LucideIcons.wrench;
  static const IconData calibration = LucideIcons.shield_check;
  static const IconData user = LucideIcons.user;

  // --- Status & Feedback ---
  static const IconData success = LucideIcons.circle_check;
  static const IconData warning = LucideIcons.triangle_alert;
  static const IconData error = LucideIcons.circle_alert;
  static const IconData info = LucideIcons.info;
  static const IconData loading = LucideIcons.loader;
  static const IconData offline = LucideIcons.wifi_off;
  static const IconData healthy = LucideIcons.heart_pulse;
  static const IconData critical = LucideIcons.octagon_alert;
}

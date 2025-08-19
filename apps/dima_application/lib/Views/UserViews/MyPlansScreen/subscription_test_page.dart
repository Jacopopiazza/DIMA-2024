// subscription_test_page.dart (FIXED VERSION)
import 'package:dima_application/services/meal_plan_subscription_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; // Aggiunto per JSON parsing
import 'package:dima_application/generated/flutter-models/ModelProvider.dart';

class SubscriptionTestPage extends StatefulWidget {
  const SubscriptionTestPage({super.key});

  @override
  State<SubscriptionTestPage> createState() => _SubscriptionTestPageState();
}

class _SubscriptionTestPageState extends State<SubscriptionTestPage> {
  late MealPlanSubscriptionService _subscriptionService;
  StreamSubscription<MealPlanResponse>? _notificationSubscription;
  List<String> _logs = [];
  bool _isListening = false;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _addLog("📱 Widget inizializzato");
    _initializeSubscription();
  }

  Future<void> _initializeSubscription() async {
    _addLog("🔧 Inizializzazione subscription service...");
    _subscriptionService = MealPlanSubscriptionService();
    
    try {
      _addLog("🚀 Avviando subscription...");
      
      // Avvia la subscription
      await _subscriptionService.startListening();
      _addLog("✅ Subscription avviata con successo!");
      
      // Ascolta le notifiche
      _notificationSubscription = _subscriptionService.notificationStream.listen(
        _onNotificationReceived,
        onError: _onSubscriptionError,
        onDone: () {
          _addLog("🏁 Stream completato");
          setState(() {
            _isListening = false;
          });
        },
      );
      
      setState(() {
        _isListening = true;
      });
      
      _addLog("👂 In ascolto per notifiche...");
      
    } catch (e) {
      _addLog("❌ Errore nell'inizializzazione: $e");
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onNotificationReceived(MealPlanResponse notification) {
    _notificationCount++;
    
    _addLog("📨 NOTIFICA RICEVUTA #$_notificationCount:");
    _addLog("   ├─ Success: ${notification.success}");
    _addLog("   ├─ Message: ${notification.message ?? 'null'}");
    _addLog("   └─ MealPlanId: ${notification.mealPlanId}");
    
    // Stampa anche nella console
    print("🔔 MEAL PLAN NOTIFICATION #$_notificationCount:");
    print("   Success: ${notification.success}");
    print("   Message: ${notification.message}");
    print("   MealPlanId: ${notification.mealPlanId}");
    print("   Timestamp: ${DateTime.now()}");
    print("─" * 50);
    
    setState(() {});
  }

  void _onSubscriptionError(dynamic error) {
    _addLog("💥 ERRORE SUBSCRIPTION: $error");
    print("❌ SUBSCRIPTION ERROR: $error");
    
    setState(() {
      _isListening = false;
    });
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = "[$timestamp] $message";
    
    setState(() {
      _logs.insert(0, logMessage);
      // Mantieni solo gli ultimi 100 log
      if (_logs.length > 100) {
        _logs.removeLast();
      }
    });
    
    // Stampa anche nella console
    print(logMessage);
  }

  Future<void> _restartSubscription() async {
    _addLog("🔄 Riavvio subscription...");
    
    await _subscriptionService.stopListening();
    await _notificationSubscription?.cancel();
    
    setState(() {
      _isListening = false;
      _notificationCount = 0;
    });
    
    await _initializeSubscription();
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _notificationCount = 0;
    });
    _addLog("🧹 Log puliti");
  }

  @override
  void dispose() {
    _addLog("🛑 Disposing widget...");
    _notificationSubscription?.cancel();
    _subscriptionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Forza tema chiaro per questa pagina
    return Theme(
      data: ThemeData.light().copyWith(
        // Override per essere sicuri che tutto sia leggibile
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: _isListening ? Colors.green : Colors.red,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black87,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white, // Forza sfondo bianco
        appBar: AppBar(
          title: const Text('Subscription Test'),
          backgroundColor: _isListening ? Colors.green : Colors.red,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearLogs,
              tooltip: 'Pulisci log',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _restartSubscription,
              tooltip: 'Riavvia subscription',
            ),
          ],
        ),
        body: Column(
          children: [
            // Status header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isListening ? Colors.green.shade100 : Colors.red.shade100,
                border: Border(
                  bottom: BorderSide(
                    color: _isListening ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isListening ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: _isListening ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isListening ? 'SUBSCRIPTION ATTIVA' : 'SUBSCRIPTION NON ATTIVA',
                        style: TextStyle(
                          color: _isListening ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (_notificationCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Notifiche ricevute: $_notificationCount',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Logs list
            Expanded(
              child: Container(
                color: Colors.white, // Assicura sfondo bianco
                child: _logs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Nessun log ancora...',
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'In attesa di notifiche dalla subscription',
                              style: TextStyle(
                                fontSize: 14, 
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[index];
                          final isNotification = log.contains('NOTIFICA RICEVUTA') || 
                                               log.contains('ERRORE SUBSCRIPTION');
                          
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isNotification ? Colors.blue.shade50 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: isNotification 
                                  ? Border.all(color: Colors.blue.shade200)
                                  : Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListTile(
                              dense: true,
                              leading: _getLogIcon(log),
                              title: Text(
                                log,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  fontWeight: isNotification ? FontWeight.bold : FontWeight.normal,
                                  color: _getLogColor(log),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isListening)
              FloatingActionButton(
                onPressed: _restartSubscription,
                backgroundColor: Colors.green,
                heroTag: "restart",
                child: const Icon(Icons.play_arrow, color: Colors.white),
                tooltip: 'Avvia subscription',
              ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: _clearLogs,
              backgroundColor: Colors.orange,
              heroTag: "clear",
              child: const Icon(Icons.clear_all, color: Colors.white),
              tooltip: 'Pulisci log',
            ),
          ],
        ),
      ),
    );
  }

  Icon _getLogIcon(String log) {
    if (log.contains('📨') || log.contains('NOTIFICA RICEVUTA')) {
      return const Icon(Icons.notification_important, color: Colors.blue, size: 16);
    } else if (log.contains('❌') || log.contains('💥')) {
      return const Icon(Icons.error, color: Colors.red, size: 16);
    } else if (log.contains('✅')) {
      return const Icon(Icons.check_circle, color: Colors.green, size: 16);
    } else if (log.contains('🔄') || log.contains('🚀')) {
      return const Icon(Icons.sync, color: Colors.orange, size: 16);
    } else {
      return const Icon(Icons.info_outline, color: Colors.grey, size: 16);
    }
  }

  Color _getLogColor(String log) {
    if (log.contains('❌') || log.contains('💥')) {
      return Colors.red.shade700;
    } else if (log.contains('✅')) {
      return Colors.green.shade700;
    } else if (log.contains('📨') || log.contains('NOTIFICA RICEVUTA')) {
      return Colors.blue.shade700;
    } else if (log.contains('🔄') || log.contains('🚀')) {
      return Colors.orange.shade700;
    } else {
      return Colors.black87;
    }
  }
}
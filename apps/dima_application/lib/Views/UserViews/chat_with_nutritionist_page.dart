import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Optional: Define specific colors if needed
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 3; // Start with Chat selected
  final TextEditingController _messageController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get status bar height for padding if needed, though Scaffold handles it
    // final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      // AppBar is simple, title only matching the top "Chat" text
      appBar: AppBar(
        backgroundColor: Colors.white, // Or Colors.transparent if blending with body
        elevation: 0, // No shadow
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: null, // No back button shown in the image
        automaticallyImplyLeading: false, // Ensure no default back button appears
      ),
      backgroundColor: Colors.white, // Background for the body area
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Builds the main content area (profile header, messages, input)
  Widget _buildBody() {
    return Column(
      children: [
        _buildProfileHeader(),
        const Divider(height: 1, thickness: 1, color: Colors.black12), // Optional divider
        Expanded(child: _buildMessagesList()),
        _buildMessageInputArea(),
      ],
    );
  }

  // Builds the header section below the AppBar
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center items in the row
        children: [
          // Left side: Avatar and Text (using Column for vertical alignment)
          const Row(
            children: [
              CircleAvatar(
                radius: 20,
                // Replace with your actual image asset
                backgroundImage: AssetImage('assets/avatar1.png'), // Placeholder
              ),
              SizedBox(width: 12), // Spacing between avatar and text
              // Text element is actually below the avatar level in the example
              // Let's adjust the layout - Text centered in the middle area
            ],
          ),

          // Center: Text
          const Text(
            'Your personal nutritionist',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          // Right side: Menu Icon
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black54),
            onPressed: () {
              // Handle menu tap
            },
          ),
        ],
      ),
    );
  }


  // Builds the scrollable list of messages
  Widget _buildMessagesList() {
    // Use ListView.builder for better performance with many messages
    // For this example, ListView is sufficient
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      reverse: false, // To keep messages starting from the top as in screenshot
      children: [
        // Timestamp
        _buildTimestamp('Monday 12:38 PM'),
        const SizedBox(height: 15),

        // Incoming Message
        _buildIncomingMessage(
          'Let\'s get lunch. Do you like what\'s today?',
          'assets/avatar2.png', // Use a different avatar for the sender
        ),
        const SizedBox(height: 10),

        // Outgoing Message
        _buildOutgoingMessage(
          'Yes! I love it! I\'m enjoying food more than ever.',
        ),
        const SizedBox(height: 10),

        // Add more messages here...
      ],
    );
  }

  // Helper to build timestamp dividers
  Widget _buildTimestamp(String time) {
    return Center(
      child: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  // Helper to build incoming message bubbles
  Widget _buildIncomingMessage(String text, String avatarAsset) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // Align avatar bottom with bubble bottom
      children: [
         CircleAvatar(
           radius: 15,
           backgroundImage: AssetImage(avatarAsset), // Sender's avatar
         ),
        const SizedBox(width: 8),
        Flexible( // Allows the bubble to wrap text and not overflow
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light grey for incoming
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4), // Slightly less rounded corner near tail
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 50), // Pushes bubble away from the right edge
      ],
    );
  }

  // Helper to build outgoing message bubbles
  Widget _buildOutgoingMessage(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align bubble to the right
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 50), // Pushes bubble away from the left edge
        Flexible( // Allows the bubble to wrap text and not overflow
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.blue, // Blue for outgoing
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4), // Slightly less rounded corner near tail
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        // No avatar for outgoing messages in this design
      ],
    );
  }

  // Builds the text input area at the bottom
  Widget _buildMessageInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white, // Or Theme.of(context).cardColor
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black54),
            onPressed: () { /* Handle camera */ },
          ),
          IconButton(
            icon: const Icon(Icons.apps, color: Colors.black54), // Placeholder like App Store icon
            onPressed: () { /* Handle apps/attachments */ },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2.0), // Slight internal padding
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  enabledBorder: OutlineInputBorder( // Border when not focused
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder( // Border when focused
                     borderRadius: BorderRadius.circular(20.0),
                     borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adjust padding inside text field
                  isDense: true, // Make it more compact vertically
                ),
                onSubmitted: (value) { /* Handle message send */ },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic_none_outlined, color: Colors.black54), // Or Icons.mic
             // Visual change for mic icon in the image looks like a waveform inside circle
            // Icon(Icons.settings_voice, color: Colors.black54), // Alternative
            // Using a custom icon or image might be needed for exact match
             onPressed: () { /* Handle voice input */ },
             // For the exact waveform style, you might need a custom painter or an image icon.
             // Let's use a placeholder that looks similar:
             // icon: Container(
             //   padding: EdgeInsets.all(4),
             //   decoration: BoxDecoration(
             //     shape: BoxShape.circle,
             //     border: Border.all(color: Colors.grey)
             //   ),
             //   child: Icon(Icons.graphic_eq, size: 18, color: Colors.grey[600])
             // )
          ),
        ],
      ),
    );
  }

  // Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    const Color selectedColor = Colors.deepPurple; // Color for selected item
    const Color unselectedColor = Colors.grey;    // Color for unselected items

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny_outlined),
          label: 'Today',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu_outlined), // Or Icons.set_meal_outlined
          label: 'Meal Plan',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          label: 'Grocery List',
        ),
        BottomNavigationBarItem(
          // Wrap Icon in Stack for the notification dot
          icon: Stack(
            clipBehavior: Clip.none, // Allow dot to go outside icon bounds slightly
            children: [
              const Icon(Icons.chat_bubble_outline), // Use outline for unselected state
              Positioned(
                top: -3, // Adjust position as needed
                right: -5, // Adjust position as needed
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 8, // Dot size
                    minHeight: 8,
                  ),
                ),
              )
            ],
          ),
           activeIcon: Stack( // Define active icon separately if needed, or rely on color
             clipBehavior: Clip.none,
             children: [
               const Icon(Icons.chat_bubble), // Filled icon for selected state
               Positioned(
                 top: -3,
                 right: -5,
                 child: Container(
                   padding: const EdgeInsets.all(2),
                   decoration: const BoxDecoration(
                     color: Colors.red,
                     shape: BoxShape.circle,
                   ),
                   constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                 ),
               )
             ],
           ),
          label: 'Chat',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, // Ensures all labels are shown
      backgroundColor: Colors.white,      // Background of the Nav Bar
      elevation: 5.0,                     // Adds a slight shadow
      showUnselectedLabels: true,         // Make sure unselected labels are visible
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    );
  }
}
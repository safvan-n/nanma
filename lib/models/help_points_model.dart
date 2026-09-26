class HelpPointTransaction {
  final String id;
  final String title;
  final int points;
  final bool isEarned;
  final String date;

  const HelpPointTransaction({
    required this.id,
    required this.title,
    required this.points,
    required this.isEarned,
    required this.date,
  });
}

class HelpPointsModel {
  final int currentPoints;
  final int totalEarned;
  final int totalUsed;
  final int peopleHelped;
  final double rating;
  final List<String> achievements;
  final List<HelpPointTransaction> history;

  const HelpPointsModel({
    this.currentPoints = 240,
    this.totalEarned = 580,
    this.totalUsed = 340,
    this.peopleHelped = 24,
    this.rating = 4.9,
    this.achievements = const [
      'Kind Helper',
      '5 Requests Completed',
      '10 Helpers Supported',
      'Community Champion',
    ],
    this.history = const [
      HelpPointTransaction(
        id: 'tx1',
        title: 'Completed Grocery Delivery',
        points: 50,
        isEarned: true,
        date: '20 Sep 2026',
      ),
      HelpPointTransaction(
        id: 'tx2',
        title: 'Discount redeemed on Medicine order',
        points: 100,
        isEarned: false,
        date: '15 Sep 2026',
      ),
      HelpPointTransaction(
        id: 'tx3',
        title: 'Assisted Senior Citizen Errand',
        points: 80,
        isEarned: true,
        date: '10 Sep 2026',
      ),
    ],
  });
}

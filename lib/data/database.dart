import 'package:book_on/screens/goals_screen.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Books extends Table {
  @override
  Set<Column> get primaryKey => {id};
  IntColumn get id => integer().autoIncrement()();

  IntColumn get bookLogId =>
      integer().nullable().customConstraint('NULL REFERENCES bookLogs(id)')();

  TextColumn get title => text().withLength(max: 128)();
  TextColumn get author => text().withLength(max: 64)();
  DateTimeColumn get createdAt => dateTime()();
  BlobColumn get image => blob()();
  IntColumn get pagesAmount => integer()();
}

class BookLogs extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentPage => integer().nullable()();
  DateTimeColumn get sessionDate => dateTime()();
  BoolColumn get isFinished => boolean()();
  DateTimeColumn get finishedDate => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
}

class BookWithLog {
  final Book book;
  final BookLog log;

  BookWithLog(this.book, this.log);
}

class Goals extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalAmount => integer()();
  IntColumn get type => intEnum<GoalType>()();
  DateTimeColumn get createdAt => dateTime()();
}

class Quotes extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get author => text().withLength(max: 64)();
  TextColumn get quoteText => text().withLength(max: 128)();
  TextColumn get imageUri => text().withLength(max: 64)();
}

@UseMoor(
    tables: [Books, Goals, Quotes, BookLogs],
    daos: [BooksDao, BookLogsDao, GoalsDao, QuotesDao])
class AppDatabase extends _$AppDatabase {
  static AppDatabase _singleton = AppDatabase._internal();

  final int version = 1;

  factory AppDatabase() {
    return _singleton;
  }

  AppDatabase._internal()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "database.db", logStatements: true));

  int get schemaVersion => 1;
}

@UseDao(
  tables: [Books, BookLogs],
)
class BooksDao extends DatabaseAccessor<AppDatabase> with _$BooksDaoMixin {
  final AppDatabase db;

  BooksDao(this.db) : super(db);

  // BOOKS
  Future<List<Book>> getBooks() => (select(books)
        ..orderBy([
          (book) =>
              OrderingTerm(expression: book.createdAt, mode: OrderingMode.desc)
        ]))
      .get();

  Stream<List<BookWithLog>> watchBookWithLogs() {
    return (select(books)
          ..orderBy(
            [
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)
            ],
          ))
        .join(
          [
            innerJoin(bookLogs, bookLogs.id.equalsExp(books.bookLogId)),
          ],
        )
        .watch()
        .map((rows) => rows.map(
              (row) {
                return BookWithLog(
                  row.readTable(books),
                  row.readTable(bookLogs),
                );
              },
            )
        .toList());
  }

  Future<Book?> findBookById(int id) =>
      (select(books)..where((b) => b.id.equals(id))).getSingleOrNull();
  Future<int> insertBook(BooksCompanion book) => into(books).insert(book);
  Future<bool> updateBook(BooksCompanion book) => update(books).replace(book);
  Future<int> deleteBook(book) => delete(books).delete(book);
  Stream<List<Book>> watchAllBooks() => select(books).watch();
}

@UseDao(tables: [BookLogs])
class BookLogsDao extends DatabaseAccessor<AppDatabase>
    with _$BookLogsDaoMixin {
  final AppDatabase db;

  BookLogsDao(this.db) : super(db);

  Future<BookLog?> findBookLogById(int id) =>
      (select(bookLogs)..where((b) => b.id.equals(id))).getSingleOrNull();
  Stream<List<BookLog>> watchBookLogs() => select(bookLogs).watch();
  Future<int> insertBookLog(BookLogsCompanion log) => into(bookLogs).insert(log);
  Future<bool> updateBookLog(BookLog bookLog) => update(bookLogs).replace(bookLog);
  Future<bool> updateBookLogsCompanion(BookLogsCompanion bookLog) => update(bookLogs).replace(bookLog);
  Future<int> deleteBookLog(int bookLogId) async {
    var bookLog = await findBookLogById(bookLogId);
    if (bookLog != null) {
      return delete(bookLogs).delete(bookLog);
    }
    return 0;
  } 
}

@UseDao(tables: [Goals])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  final AppDatabase db;

  GoalsDao(this.db) : super(db);

  Future<List<Goal>> getGoals() => select(goals).get();

  Future<Goal?> findBookByType(GoalType type) =>
      (select(goals)..where((b) => b.type.equals(type.index))).getSingleOrNull();
  Future<int> insertGoal(GoalsCompanion goal) => into(goals).insert(goal);
  Future<bool> updateGoal(Goal goal) => update(goals).replace(goal);
  Future<int> deleteGoal(goal) => delete(goals).delete(goal);

  Future<Goal?> existsGoal(GoalType type) =>
      (select(goals)..where((g) => g.type.equals(type.index)))
          .getSingleOrNull();

  Stream<List<Goal>> watchAllGoals() => select(goals).watch();
}

@UseDao(tables: [Quotes])
class QuotesDao extends DatabaseAccessor<AppDatabase> with _$QuotesDaoMixin {
  final AppDatabase db;

  QuotesDao(this.db) : super(db);

  Future<List<Quote>> getQuotes() => (select(quotes)
        ..orderBy([
          (goal) =>
              OrderingTerm(expression: goal.createdAt, mode: OrderingMode.desc)
        ]))
      .get();

  Future<Quote?> findQueryById(int id) =>
      (select(quotes)..where((b) => b.id.equals(id))).getSingleOrNull();
  Future<int> insertQuote(QuotesCompanion quote) => into(quotes).insert(quote);
  Future<bool> updateQuote(QuotesCompanion quote) => update(quotes).replace(quote);
  Future<int> deleteQuote(quote) => delete(quotes).delete(quote);

  Stream<List<Quote>> watchAllQuotes() => select(quotes).watch();
}

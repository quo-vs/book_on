// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Book extends DataClass implements Insertable<Book> {
  final int id;
  final int? bookLogId;
  final String title;
  final String author;
  final DateTime createdAt;
  final Uint8List image;
  final int pagesAmount;
  Book(
      {required this.id,
      this.bookLogId,
      required this.title,
      required this.author,
      required this.createdAt,
      required this.image,
      required this.pagesAmount});
  factory Book.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Book(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      bookLogId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}book_log_id']),
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      author: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}author'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      image: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image'])!,
      pagesAmount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}pages_amount'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || bookLogId != null) {
      map['book_log_id'] = Variable<int?>(bookLogId);
    }
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['image'] = Variable<Uint8List>(image);
    map['pages_amount'] = Variable<int>(pagesAmount);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      bookLogId: bookLogId == null && nullToAbsent
          ? const Value.absent()
          : Value(bookLogId),
      title: Value(title),
      author: Value(author),
      createdAt: Value(createdAt),
      image: Value(image),
      pagesAmount: Value(pagesAmount),
    );
  }

  factory Book.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      bookLogId: serializer.fromJson<int?>(json['bookLogId']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      image: serializer.fromJson<Uint8List>(json['image']),
      pagesAmount: serializer.fromJson<int>(json['pagesAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookLogId': serializer.toJson<int?>(bookLogId),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'image': serializer.toJson<Uint8List>(image),
      'pagesAmount': serializer.toJson<int>(pagesAmount),
    };
  }

  Book copyWith(
          {int? id,
          int? bookLogId,
          String? title,
          String? author,
          DateTime? createdAt,
          Uint8List? image,
          int? pagesAmount}) =>
      Book(
        id: id ?? this.id,
        bookLogId: bookLogId ?? this.bookLogId,
        title: title ?? this.title,
        author: author ?? this.author,
        createdAt: createdAt ?? this.createdAt,
        image: image ?? this.image,
        pagesAmount: pagesAmount ?? this.pagesAmount,
      );
  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('bookLogId: $bookLogId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('image: $image, ')
          ..write('pagesAmount: $pagesAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          bookLogId.hashCode,
          $mrjc(
              title.hashCode,
              $mrjc(
                  author.hashCode,
                  $mrjc(createdAt.hashCode,
                      $mrjc(image.hashCode, pagesAmount.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.bookLogId == this.bookLogId &&
          other.title == this.title &&
          other.author == this.author &&
          other.createdAt == this.createdAt &&
          other.image == this.image &&
          other.pagesAmount == this.pagesAmount);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<int?> bookLogId;
  final Value<String> title;
  final Value<String> author;
  final Value<DateTime> createdAt;
  final Value<Uint8List> image;
  final Value<int> pagesAmount;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.bookLogId = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.image = const Value.absent(),
    this.pagesAmount = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    this.bookLogId = const Value.absent(),
    required String title,
    required String author,
    required DateTime createdAt,
    required Uint8List image,
    required int pagesAmount,
  })  : title = Value(title),
        author = Value(author),
        createdAt = Value(createdAt),
        image = Value(image),
        pagesAmount = Value(pagesAmount);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<int?>? bookLogId,
    Expression<String>? title,
    Expression<String>? author,
    Expression<DateTime>? createdAt,
    Expression<Uint8List>? image,
    Expression<int>? pagesAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookLogId != null) 'book_log_id': bookLogId,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (createdAt != null) 'created_at': createdAt,
      if (image != null) 'image': image,
      if (pagesAmount != null) 'pages_amount': pagesAmount,
    });
  }

  BooksCompanion copyWith(
      {Value<int>? id,
      Value<int?>? bookLogId,
      Value<String>? title,
      Value<String>? author,
      Value<DateTime>? createdAt,
      Value<Uint8List>? image,
      Value<int>? pagesAmount}) {
    return BooksCompanion(
      id: id ?? this.id,
      bookLogId: bookLogId ?? this.bookLogId,
      title: title ?? this.title,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      image: image ?? this.image,
      pagesAmount: pagesAmount ?? this.pagesAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookLogId.present) {
      map['book_log_id'] = Variable<int?>(bookLogId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (image.present) {
      map['image'] = Variable<Uint8List>(image.value);
    }
    if (pagesAmount.present) {
      map['pages_amount'] = Variable<int>(pagesAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('bookLogId: $bookLogId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('image: $image, ')
          ..write('pagesAmount: $pagesAmount')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BooksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _bookLogIdMeta = const VerificationMeta('bookLogId');
  late final GeneratedColumn<int?> bookLogId = GeneratedColumn<int?>(
      'book_log_id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES bookLogs(id)');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _authorMeta = const VerificationMeta('author');
  late final GeneratedColumn<String?> author = GeneratedColumn<String?>(
      'author', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _imageMeta = const VerificationMeta('image');
  late final GeneratedColumn<Uint8List?> image = GeneratedColumn<Uint8List?>(
      'image', aliasedName, false,
      typeName: 'BLOB', requiredDuringInsert: true);
  final VerificationMeta _pagesAmountMeta =
      const VerificationMeta('pagesAmount');
  late final GeneratedColumn<int?> pagesAmount = GeneratedColumn<int?>(
      'pages_amount', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookLogId, title, author, createdAt, image, pagesAmount];
  @override
  String get aliasedName => _alias ?? 'books';
  @override
  String get actualTableName => 'books';
  @override
  VerificationContext validateIntegrity(Insertable<Book> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_log_id')) {
      context.handle(
          _bookLogIdMeta,
          bookLogId.isAcceptableOrUnknown(
              data['book_log_id']!, _bookLogIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    } else if (isInserting) {
      context.missing(_imageMeta);
    }
    if (data.containsKey('pages_amount')) {
      context.handle(
          _pagesAmountMeta,
          pagesAmount.isAcceptableOrUnknown(
              data['pages_amount']!, _pagesAmountMeta));
    } else if (isInserting) {
      context.missing(_pagesAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Book.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(_db, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final int goalAmount;
  final GoalType type;
  final DateTime createdAt;
  Goal(
      {required this.id,
      required this.goalAmount,
      required this.type,
      required this.createdAt});
  factory Goal.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Goal(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      goalAmount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}goal_amount'])!,
      type: $GoalsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}type']))!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_amount'] = Variable<int>(goalAmount);
    {
      final converter = $GoalsTable.$converter0;
      map['type'] = Variable<int>(converter.mapToSql(type)!);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      goalAmount: Value(goalAmount),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      goalAmount: serializer.fromJson<int>(json['goalAmount']),
      type: serializer.fromJson<GoalType>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalAmount': serializer.toJson<int>(goalAmount),
      'type': serializer.toJson<GoalType>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Goal copyWith(
          {int? id, int? goalAmount, GoalType? type, DateTime? createdAt}) =>
      Goal(
        id: id ?? this.id,
        goalAmount: goalAmount ?? this.goalAmount,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(goalAmount.hashCode, $mrjc(type.hashCode, createdAt.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.goalAmount == this.goalAmount &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<int> goalAmount;
  final Value<GoalType> type;
  final Value<DateTime> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.goalAmount = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required int goalAmount,
    required GoalType type,
    required DateTime createdAt,
  })  : goalAmount = Value(goalAmount),
        type = Value(type),
        createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<int>? goalAmount,
    Expression<GoalType>? type,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalAmount != null) 'goal_amount': goalAmount,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? goalAmount,
      Value<GoalType>? type,
      Value<DateTime>? createdAt}) {
    return GoalsCompanion(
      id: id ?? this.id,
      goalAmount: goalAmount ?? this.goalAmount,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalAmount.present) {
      map['goal_amount'] = Variable<int>(goalAmount.value);
    }
    if (type.present) {
      final converter = $GoalsTable.$converter0;
      map['type'] = Variable<int>(converter.mapToSql(type.value)!);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  final GeneratedDatabase _db;
  final String? _alias;
  $GoalsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _goalAmountMeta = const VerificationMeta('goalAmount');
  late final GeneratedColumn<int?> goalAmount = GeneratedColumn<int?>(
      'goal_amount', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumnWithTypeConverter<GoalType, int?> type =
      GeneratedColumn<int?>('type', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<GoalType>($GoalsTable.$converter0);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, goalAmount, type, createdAt];
  @override
  String get aliasedName => _alias ?? 'goals';
  @override
  String get actualTableName => 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_amount')) {
      context.handle(
          _goalAmountMeta,
          goalAmount.isAcceptableOrUnknown(
              data['goal_amount']!, _goalAmountMeta));
    } else if (isInserting) {
      context.missing(_goalAmountMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Goal.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(_db, alias);
  }

  static TypeConverter<GoalType, int> $converter0 =
      const EnumIndexConverter<GoalType>(GoalType.values);
}

class Quote extends DataClass implements Insertable<Quote> {
  final int id;
  final DateTime createdAt;
  final String author;
  final String quoteText;
  final String imageUri;
  Quote(
      {required this.id,
      required this.createdAt,
      required this.author,
      required this.quoteText,
      required this.imageUri});
  factory Quote.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Quote(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      createdAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at'])!,
      author: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}author'])!,
      quoteText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quote_text'])!,
      imageUri: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image_uri'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['author'] = Variable<String>(author);
    map['quote_text'] = Variable<String>(quoteText);
    map['image_uri'] = Variable<String>(imageUri);
    return map;
  }

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      author: Value(author),
      quoteText: Value(quoteText),
      imageUri: Value(imageUri),
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Quote(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      author: serializer.fromJson<String>(json['author']),
      quoteText: serializer.fromJson<String>(json['quoteText']),
      imageUri: serializer.fromJson<String>(json['imageUri']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'author': serializer.toJson<String>(author),
      'quoteText': serializer.toJson<String>(quoteText),
      'imageUri': serializer.toJson<String>(imageUri),
    };
  }

  Quote copyWith(
          {int? id,
          DateTime? createdAt,
          String? author,
          String? quoteText,
          String? imageUri}) =>
      Quote(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        author: author ?? this.author,
        quoteText: quoteText ?? this.quoteText,
        imageUri: imageUri ?? this.imageUri,
      );
  @override
  String toString() {
    return (StringBuffer('Quote(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('author: $author, ')
          ..write('quoteText: $quoteText, ')
          ..write('imageUri: $imageUri')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          createdAt.hashCode,
          $mrjc(
              author.hashCode, $mrjc(quoteText.hashCode, imageUri.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quote &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.author == this.author &&
          other.quoteText == this.quoteText &&
          other.imageUri == this.imageUri);
}

class QuotesCompanion extends UpdateCompanion<Quote> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> author;
  final Value<String> quoteText;
  final Value<String> imageUri;
  const QuotesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.author = const Value.absent(),
    this.quoteText = const Value.absent(),
    this.imageUri = const Value.absent(),
  });
  QuotesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String author,
    required String quoteText,
    required String imageUri,
  })  : createdAt = Value(createdAt),
        author = Value(author),
        quoteText = Value(quoteText),
        imageUri = Value(imageUri);
  static Insertable<Quote> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? author,
    Expression<String>? quoteText,
    Expression<String>? imageUri,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (author != null) 'author': author,
      if (quoteText != null) 'quote_text': quoteText,
      if (imageUri != null) 'image_uri': imageUri,
    });
  }

  QuotesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<String>? author,
      Value<String>? quoteText,
      Value<String>? imageUri}) {
    return QuotesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      quoteText: quoteText ?? this.quoteText,
      imageUri: imageUri ?? this.imageUri,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (quoteText.present) {
      map['quote_text'] = Variable<String>(quoteText.value);
    }
    if (imageUri.present) {
      map['image_uri'] = Variable<String>(imageUri.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('author: $author, ')
          ..write('quoteText: $quoteText, ')
          ..write('imageUri: $imageUri')
          ..write(')'))
        .toString();
  }
}

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, Quote> {
  final GeneratedDatabase _db;
  final String? _alias;
  $QuotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime?> createdAt = GeneratedColumn<DateTime?>(
      'created_at', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _authorMeta = const VerificationMeta('author');
  late final GeneratedColumn<String?> author = GeneratedColumn<String?>(
      'author', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _quoteTextMeta = const VerificationMeta('quoteText');
  late final GeneratedColumn<String?> quoteText = GeneratedColumn<String?>(
      'quote_text', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 128),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _imageUriMeta = const VerificationMeta('imageUri');
  late final GeneratedColumn<String?> imageUri = GeneratedColumn<String?>(
      'image_uri', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, author, quoteText, imageUri];
  @override
  String get aliasedName => _alias ?? 'quotes';
  @override
  String get actualTableName => 'quotes';
  @override
  VerificationContext validateIntegrity(Insertable<Quote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('quote_text')) {
      context.handle(_quoteTextMeta,
          quoteText.isAcceptableOrUnknown(data['quote_text']!, _quoteTextMeta));
    } else if (isInserting) {
      context.missing(_quoteTextMeta);
    }
    if (data.containsKey('image_uri')) {
      context.handle(_imageUriMeta,
          imageUri.isAcceptableOrUnknown(data['image_uri']!, _imageUriMeta));
    } else if (isInserting) {
      context.missing(_imageUriMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quote map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Quote.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(_db, alias);
  }
}

class BookLog extends DataClass implements Insertable<BookLog> {
  final int id;
  final int? currentPage;
  final DateTime sessionDate;
  final bool isFinished;
  final DateTime? finishedDate;
  final DateTime updatedAt;
  BookLog(
      {required this.id,
      this.currentPage,
      required this.sessionDate,
      required this.isFinished,
      this.finishedDate,
      required this.updatedAt});
  factory BookLog.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return BookLog(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      currentPage: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}current_page']),
      sessionDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}session_date'])!,
      isFinished: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_finished'])!,
      finishedDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}finished_date']),
      updatedAt: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || currentPage != null) {
      map['current_page'] = Variable<int?>(currentPage);
    }
    map['session_date'] = Variable<DateTime>(sessionDate);
    map['is_finished'] = Variable<bool>(isFinished);
    if (!nullToAbsent || finishedDate != null) {
      map['finished_date'] = Variable<DateTime?>(finishedDate);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BookLogsCompanion toCompanion(bool nullToAbsent) {
    return BookLogsCompanion(
      id: Value(id),
      currentPage: currentPage == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPage),
      sessionDate: Value(sessionDate),
      isFinished: Value(isFinished),
      finishedDate: finishedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedDate),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return BookLog(
      id: serializer.fromJson<int>(json['id']),
      currentPage: serializer.fromJson<int?>(json['currentPage']),
      sessionDate: serializer.fromJson<DateTime>(json['sessionDate']),
      isFinished: serializer.fromJson<bool>(json['isFinished']),
      finishedDate: serializer.fromJson<DateTime?>(json['finishedDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentPage': serializer.toJson<int?>(currentPage),
      'sessionDate': serializer.toJson<DateTime>(sessionDate),
      'isFinished': serializer.toJson<bool>(isFinished),
      'finishedDate': serializer.toJson<DateTime?>(finishedDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BookLog copyWith(
          {int? id,
          int? currentPage,
          DateTime? sessionDate,
          bool? isFinished,
          DateTime? finishedDate,
          DateTime? updatedAt}) =>
      BookLog(
        id: id ?? this.id,
        currentPage: currentPage ?? this.currentPage,
        sessionDate: sessionDate ?? this.sessionDate,
        isFinished: isFinished ?? this.isFinished,
        finishedDate: finishedDate ?? this.finishedDate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('BookLog(')
          ..write('id: $id, ')
          ..write('currentPage: $currentPage, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('isFinished: $isFinished, ')
          ..write('finishedDate: $finishedDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          currentPage.hashCode,
          $mrjc(
              sessionDate.hashCode,
              $mrjc(isFinished.hashCode,
                  $mrjc(finishedDate.hashCode, updatedAt.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookLog &&
          other.id == this.id &&
          other.currentPage == this.currentPage &&
          other.sessionDate == this.sessionDate &&
          other.isFinished == this.isFinished &&
          other.finishedDate == this.finishedDate &&
          other.updatedAt == this.updatedAt);
}

class BookLogsCompanion extends UpdateCompanion<BookLog> {
  final Value<int> id;
  final Value<int?> currentPage;
  final Value<DateTime> sessionDate;
  final Value<bool> isFinished;
  final Value<DateTime?> finishedDate;
  final Value<DateTime> updatedAt;
  const BookLogsCompanion({
    this.id = const Value.absent(),
    this.currentPage = const Value.absent(),
    this.sessionDate = const Value.absent(),
    this.isFinished = const Value.absent(),
    this.finishedDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BookLogsCompanion.insert({
    this.id = const Value.absent(),
    this.currentPage = const Value.absent(),
    required DateTime sessionDate,
    required bool isFinished,
    this.finishedDate = const Value.absent(),
    required DateTime updatedAt,
  })  : sessionDate = Value(sessionDate),
        isFinished = Value(isFinished),
        updatedAt = Value(updatedAt);
  static Insertable<BookLog> custom({
    Expression<int>? id,
    Expression<int?>? currentPage,
    Expression<DateTime>? sessionDate,
    Expression<bool>? isFinished,
    Expression<DateTime?>? finishedDate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentPage != null) 'current_page': currentPage,
      if (sessionDate != null) 'session_date': sessionDate,
      if (isFinished != null) 'is_finished': isFinished,
      if (finishedDate != null) 'finished_date': finishedDate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BookLogsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? currentPage,
      Value<DateTime>? sessionDate,
      Value<bool>? isFinished,
      Value<DateTime?>? finishedDate,
      Value<DateTime>? updatedAt}) {
    return BookLogsCompanion(
      id: id ?? this.id,
      currentPage: currentPage ?? this.currentPage,
      sessionDate: sessionDate ?? this.sessionDate,
      isFinished: isFinished ?? this.isFinished,
      finishedDate: finishedDate ?? this.finishedDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentPage.present) {
      map['current_page'] = Variable<int?>(currentPage.value);
    }
    if (sessionDate.present) {
      map['session_date'] = Variable<DateTime>(sessionDate.value);
    }
    if (isFinished.present) {
      map['is_finished'] = Variable<bool>(isFinished.value);
    }
    if (finishedDate.present) {
      map['finished_date'] = Variable<DateTime?>(finishedDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookLogsCompanion(')
          ..write('id: $id, ')
          ..write('currentPage: $currentPage, ')
          ..write('sessionDate: $sessionDate, ')
          ..write('isFinished: $isFinished, ')
          ..write('finishedDate: $finishedDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BookLogsTable extends BookLogs with TableInfo<$BookLogsTable, BookLog> {
  final GeneratedDatabase _db;
  final String? _alias;
  $BookLogsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _currentPageMeta =
      const VerificationMeta('currentPage');
  late final GeneratedColumn<int?> currentPage = GeneratedColumn<int?>(
      'current_page', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _sessionDateMeta =
      const VerificationMeta('sessionDate');
  late final GeneratedColumn<DateTime?> sessionDate =
      GeneratedColumn<DateTime?>('session_date', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _isFinishedMeta = const VerificationMeta('isFinished');
  late final GeneratedColumn<bool?> isFinished = GeneratedColumn<bool?>(
      'is_finished', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_finished IN (0, 1))');
  final VerificationMeta _finishedDateMeta =
      const VerificationMeta('finishedDate');
  late final GeneratedColumn<DateTime?> finishedDate =
      GeneratedColumn<DateTime?>('finished_date', aliasedName, true,
          typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  late final GeneratedColumn<DateTime?> updatedAt = GeneratedColumn<DateTime?>(
      'updated_at', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, currentPage, sessionDate, isFinished, finishedDate, updatedAt];
  @override
  String get aliasedName => _alias ?? 'book_logs';
  @override
  String get actualTableName => 'book_logs';
  @override
  VerificationContext validateIntegrity(Insertable<BookLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_page')) {
      context.handle(
          _currentPageMeta,
          currentPage.isAcceptableOrUnknown(
              data['current_page']!, _currentPageMeta));
    }
    if (data.containsKey('session_date')) {
      context.handle(
          _sessionDateMeta,
          sessionDate.isAcceptableOrUnknown(
              data['session_date']!, _sessionDateMeta));
    } else if (isInserting) {
      context.missing(_sessionDateMeta);
    }
    if (data.containsKey('is_finished')) {
      context.handle(
          _isFinishedMeta,
          isFinished.isAcceptableOrUnknown(
              data['is_finished']!, _isFinishedMeta));
    } else if (isInserting) {
      context.missing(_isFinishedMeta);
    }
    if (data.containsKey('finished_date')) {
      context.handle(
          _finishedDateMeta,
          finishedDate.isAcceptableOrUnknown(
              data['finished_date']!, _finishedDateMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    return BookLog.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BookLogsTable createAlias(String alias) {
    return $BookLogsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $BooksTable books = $BooksTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $BookLogsTable bookLogs = $BookLogsTable(this);
  late final BooksDao booksDao = BooksDao(this as AppDatabase);
  late final BookLogsDao bookLogsDao = BookLogsDao(this as AppDatabase);
  late final GoalsDao goalsDao = GoalsDao(this as AppDatabase);
  late final QuotesDao quotesDao = QuotesDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [books, goals, quotes, bookLogs];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$BooksDaoMixin on DatabaseAccessor<AppDatabase> {
  $BooksTable get books => attachedDatabase.books;
  $BookLogsTable get bookLogs => attachedDatabase.bookLogs;
}
mixin _$BookLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BookLogsTable get bookLogs => attachedDatabase.bookLogs;
}
mixin _$GoalsDaoMixin on DatabaseAccessor<AppDatabase> {
  $GoalsTable get goals => attachedDatabase.goals;
}
mixin _$QuotesDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuotesTable get quotes => attachedDatabase.quotes;
}

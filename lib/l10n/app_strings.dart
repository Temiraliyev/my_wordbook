enum AppLocale { uz, ru, en }

class AppStrings {
  final AppLocale locale;
  const AppStrings(this.locale);

  // --- App ---
  String get appTitle => _s("Mening lug'atim", "Мой словарь", "My Wordbook");

  // --- Common ---
  String get cancel => _s("Bekor qilish", "Отмена", "Cancel");
  String get save => _s("Saqlash", "Сохранить", "Save");
  String get delete => _s("O'chirish", "Удалить", "Delete");
  String get edit => _s("Tahrirlash", "Редактировать", "Edit");
  String get back => _s("Orqaga", "Назад", "Back");
  String get no => _s("Bekor", "Отмена", "Cancel");

  // --- Home ---
  String get groups => _s("Guruhlar", "Группы", "Groups");
  String get addGroup => _s("Guruh qo'shish", "Добавить группу", "Add group");
  String get newGroup => _s("Yangi guruh", "Новая группа", "New group");
  String get groupName => _s("Guruh nomi", "Название группы", "Group name");
  String get groupNameHint =>
      _s("Masalan: Inglizcha A1", "Например: Английский A1", "e.g. English A1");
  String get editGroup =>
      _s("Guruhni tahrirlash", "Редактировать группу", "Edit group");
  String get deleteGroupTitle => _s("O'chirish", "Удаление", "Delete");
  String deleteGroupMessage(String name) => _s(
    '"$name" guruhini o\'chirmoqchimisiz? Ichidagi barcha so\'zlar ham o\'chib ketadi.',
    'Удалить группу "$name"? Все слова в ней тоже будут удалены.',
    'Delete group "$name"? All words inside will also be removed.',
  );
  String get noGroups =>
      _s("Hech qanday guruh yo'q", "Групп пока нет", "No groups yet");
  String get noGroupsDesc => _s(
    "So'zlarni guruhlab o'rganing. Birinchi guruhingizni qo'shing!",
    "Учите слова по группам. Создайте свою первую группу!",
    "Learn words by groups. Add your first group!",
  );

  // --- Word Screen ---
  String get word => _s("So'z", "Слово", "Word");
  String get wordHint => _s("Apple", "Apple", "Apple");
  String get translation => _s("Tarjima", "Перевод", "Translation");
  String get translationHint => _s("Olma", "Яблоко", "Apple");
  String get addWord => _s("So'z qo'shish", "Добавить слово", "Add word");
  String get noWords =>
      _s("So'zlar hali yo'q", "Слов пока нет", "No words yet");
  String get noWordsDesc => _s(
    "Yuqoridagi maydondan so'z va tarjimasini kiriting.",
    "Введите слово и перевод в поля выше.",
    "Enter a word and its translation above.",
  );
  String get editWord =>
      _s("So'zni tahrirlash", "Редактировать слово", "Edit word");

  // --- Test Screen ---
  String get testNoWords =>
      _s("Test uchun so'z yo'q", "Нет слов для теста", "No words for test");
  String get testNoWordsDesc => _s(
    "Avval bu guruhga so'zlar qo'shing, keyin test boshlanadi.",
    "Сначала добавьте слова в эту группу, затем начнётся тест.",
    "Add words to this group first, then the test will start.",
  );
  String get tapToReveal =>
      _s("Ko'rish uchun bosing", "Нажмите, чтобы показать", "Tap to reveal");
  String get finish => _s("Tugatish", "Завершить", "Finish");
  String get next => _s("Keyingi", "Далее", "Next");
  String get prev => _s("Oldingi", "Назад", "Back");
  String get goBack => _s("Orqaga qaytish", "Вернуться назад", "Go back");
  String get test => _s("Test", "Тест", "Test");

  // --- Settings ---
  String get language => _s("Til", "Язык", "Language");
  String get settings => _s("Sozlamalar", "Настройки", "Settings");
  String get chooseLanguage =>
      _s("Tilni tanlang", "Выберите язык", "Choose language");

  String _s(String uz, String ru, String en) {
    switch (locale) {
      case AppLocale.uz:
        return uz;
      case AppLocale.ru:
        return ru;
      case AppLocale.en:
        return en;
    }
  }
}

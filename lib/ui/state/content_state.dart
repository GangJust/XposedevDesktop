class ContentState {
  const ContentState._();

  static StringBuffer activity = StringBuffer();
  static StringBuffer fragment = StringBuffer();
  static StringBuffer layout = StringBuffer();
  static StringBuffer findView = StringBuffer();

  static void clear() {
    activity.clear();
    fragment.clear();
    layout.clear();
    findView.clear();
  }
}

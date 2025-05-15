class HomeState {
  HomeState({required this.isLoading});

  bool isLoading;

  HomeState copyWith({bool? isLoading}) {
    return HomeState(isLoading: isLoading ?? this.isLoading);
  }
}
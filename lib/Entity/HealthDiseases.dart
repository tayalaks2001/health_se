class HealthDisease {
  final String id;
  final String diseaseName;
  final String diseaseType;
  final String recommendedDiet;
  final List<dynamic> suggestion;
  final List<dynamic> measure;

  HealthDisease(
      {this.id,
      this.diseaseName,
      this.diseaseType,
      this.recommendedDiet,
      this.suggestion,
      this.measure});

  factory HealthDisease.fromJson(Map<String, dynamic> json) {
    return HealthDisease(
      id: json['_id'] as String,
      diseaseName: json['diseaseName'] as String,
      diseaseType: json['diseaseType'] as String,
      recommendedDiet: json['recommendedDiet'] as String,
      suggestion: json['suggestion'] as List<dynamic>,
      measure: json['measure'] as List<dynamic>,
    );
  }

  String getDiseaseID() {
    return id;
  }

  String getDiseaseName() {
    return diseaseName;
  }

  String getDiseaseType() {
    return diseaseType;
  }

  String getRecommendedDiet() {
    return recommendedDiet;
  }

  String getSuggestion() {
    String suggestionText = '';
    for (int i = 0; i < suggestion.length; i++) {
      suggestionText = suggestionText + suggestion[i]["suggestion"] + '\n';
    }
    return suggestionText;
  }

  String getMeasures() {
    String measureText = '';
    for (int i = 0; i < measure.length; i++) {
      measureText = measureText + measure[i]["measure"] + '\n';
    }
    return measureText;
  }
}

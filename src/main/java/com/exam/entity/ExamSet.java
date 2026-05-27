package com.exam.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "exam_sets")
public class ExamSet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String languageName;

    private String setName;

    @Column(columnDefinition = "LONGTEXT")
    private String mcqIds;

    private Long codingQuestionId;

    public ExamSet() {
        super();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLanguageName() {
        return languageName;
    }

    public void setLanguageName(String languageName) {
        this.languageName = languageName;
    }

    public String getSetName() {
        return setName;
    }

    public void setSetName(String setName) {
        this.setName = setName;
    }

    public String getMcqIds() {
        return mcqIds;
    }

    public void setMcqIds(String mcqIds) {
        this.mcqIds = mcqIds;
    }

    public Long getCodingQuestionId() {
        return codingQuestionId;
    }

    public void setCodingQuestionId(Long codingQuestionId) {
        this.codingQuestionId = codingQuestionId;
    }
}
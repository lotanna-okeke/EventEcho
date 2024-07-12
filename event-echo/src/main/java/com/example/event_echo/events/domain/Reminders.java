package com.example.event_echo.events.domain;

import java.util.List;

public class Reminders {

    private boolean recurring;
    private List<ReminderType> types;

    public Reminders(boolean recurring, List<ReminderType> types) {
        this.recurring = recurring;
        this.types = types;
    }

    public boolean isRecurring() {
        return recurring;
    }

    public List<ReminderType> getTypes() {
        return types;
    }

    public enum ReminderType {
        DAILY, WEEKLY, MONTHLY, YEARLY, DAY_BEFORE, WEEK_BEFORE, MONTH_BEFORE, YEAR_BEFORE
    }
}
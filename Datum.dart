// ignore_for_file: file_names

bool leapYear(int year) {
  bool boolOne = (year % 4 == 0);
  bool boolTwo = (year % 100 == 0);
  bool boolThree = (year % 400 == 0);
  bool boolTotal = boolThree || (boolOne && (!boolTwo));
  return boolTotal;
}

int getDaysOfYear(int year) {
  if (leapYear(year)) {
    return 366;
  } else {
    return 365;
  }
}

int getDaysOfMonth(int year, int month) {
  if (month == 2) {
    if (leapYear(year)) {
      return 29;
    } else {
      return 28;
    }
  } else if (month < 8) {
    if (month % 2 == 0) {
      return 30;
    } else {
      return 31;
    }
  } else if (month % 2 == 0) {
    return 31;
  } else {
    return 30;
  }
}
/*
//negative if date1 < date2, else positive
//returns date1 - date2
int getDayDistance(int year1, int month1, int day1, int year2, int month2, int day2){
    int days = 0;
    bool check = false;
    if (year1 > year2){
        days = days + getDaysOfMonth(year2, month2) - day2;
        for (int i = month2; i <= 12; i = i + 1) {
            days = days + getDaysOfMonth(year2, i);
        }
        for (int i = year2; i < year1; i = i + 1) {
            days = days + getDaysOfYear(i);
        }
        for i in range(1, month1):
            days += getDaysOfMonth(year1, i)
        days += day1
    }
    else if (year1 < year2){
        check = True
        days += getDaysOfMonth(year1, month1) - day1
        for i in range(month1 + 1, 13):
            days += getDaysOfMonth(year1, i)
        for i in range(year1 + 1, year2):
            days += getDaysOfYear(i)
        for i in range(1, month2):
            days += getDaysOfMonth(year2, i)
        days += day2
    }
    else {
        if month1 > month2:
            days += getDaysOfMonth(year2, month2) - day2
            for i in range(month2 + 1, month1):
                days += getDaysOfMonth(year2, i)
            days += day1
        elif month1 < month2:
            check = True
            days += getDaysOfMonth(year1, month1) - day1
            for i in range(month1 + 1, month2):
                days += getDaysOfMonth(year1, i)
            days += day2
        else:
            if day1 > day2:
                days = day1 - day2
            elif day1 < day2:
                check = True
                days = day2 - day1
            else:
                return 0
    }
    if (check) {
        days = 0 - days
    }
    return days
}

def getDay(year, month, day):
    names = ["Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"]
    days = getDayDistance(year, month, day, 2022, 10, 24)
    if days < 0:
        days = 0 - days
        days %= 7
        days = 8 - days
        if days == 8:
            days = 1
        days -= 1
    else:
        days %= 7
    return names[days]

def getMonth(month):
    names = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
    return names[month - 1]

def monthToInt(month):
    names = {"Januar" : 1, "Februar" : 2, "März" : 3, "April" : 4, "Mai" : 5, "Juni" : 6, "Juli" : 7, "August" : 8, "September" : 9, "Oktober" : 10, "November" : 11, "Dezember" : 12}
    return names.get(month)

def dateToString(year, month, day):
    result = formatNumber(day) + "." + formatNumber(month) + "." + str(year)
    return result

#number is a String!
def stringToDate(number):
    result = [int(number[0:4]), int(number[4:6]), int(number[6:8])]
    return result
		
def formatNumber(number):
    if number < 10:
        return "0" + str(number)
    else:
        return str(number)

def maxOfDatums(datumListe):
    if not isinstance(datumListe,list):
        return None
    if len(datumListe) == 0:
        return None
    result = datumListe[0]
    for element in datumListe:
        if result[0] < element[0]:
            result = element
        elif result[0] == element[0]:
            if result[1] < element[1]:
                result = element
            elif result[1] == element[1]:
                if result[2] < element[2]:
                    result = element
    return result

def minOfDatums(datumListe):
    if not isinstance(datumListe,list):
        return None
    if len(datumListe) == 0:
        return None
    result = datumListe[0]
    for element in datumListe:
        if result[0] > element[0]:
            result = element
        elif result[0] == element[0]:
            if result[1] > element[1]:
                result = element
            elif result[1] == element[1]:
                if result[2] > element[2]:
                    result = element
    return result

def increaseDatum(year, month, day):
    if day < getDaysOfMonth(year, month):
        return([year, month, day + 1])
    elif month < 12:
        return([year, month + 1, 1])
    else:
        return([year + 1, 1, 1])

def decreaseDatum(year, month, day):
    if day > 1:
        return([year, month, day - 1])
    elif month > 1:
        return([year, month - 1, getDaysOfMonth(year, month - 1)])
    else:
        return([year - 1, 12, 31])

import copy

def getDatumRange(datum, länge):
    newDatum = copy.deepcopy(datum)
    result = []
    for i in range(0, länge):
        result.append(copy.deepcopy(newDatum))
        newDatum = increaseDatum(newDatum[0], newDatum[1], newDatum[2])
    return result

def dateToStringClass(datum):
    result = formatNumber(datum.day) + "." + formatNumber(datum.month) + "." + str(datum.year)
    return result

def subtractDaynames(day1, day2):
    dayDict = {"Montag": 0, "Dienstag": 1, "Mittwoch": 2, "Donnerstag": 3, "Freitag": 4, "Samstag": 5, "Sonntag": 6}
    result = dayDict.get(day2) - dayDict.get(day1)
    return result

def getDayOfWeek(datum, day):
    result = copy.deepcopy(datum)
    val = subtractDaynames(day, getDay(result.year, result.month, result.day))
    if val < 0:
        result += abs(val)
    elif val > 0:
        result -= val
    return result

import PopUp

class Date:
    def __init__(self, initlist):
        self.year = initlist[0]
        self.month = initlist[1]
        self.day = initlist[2]

    def __add__(self, numberOfDays):
        selfCopy = copy.deepcopy(self)
        for i in range(0, numberOfDays):
            selfCopy = Date(increaseDatum(selfCopy.year, selfCopy.month, selfCopy.day))
        return selfCopy

    def __sub__(self, otherDateOrInt):
        if type(self) == type(otherDateOrInt):
            return getDayDistance(self.year, self.month, self.day, otherDateOrInt.year, otherDateOrInt.month, otherDateOrInt.day)
        elif isinstance(otherDateOrInt, int):
            selfCopy = copy.deepcopy(self)
            for i in range(0, otherDateOrInt):
                selfCopy = Date(decreaseDatum(selfCopy.year, selfCopy.month, selfCopy.day))
            return selfCopy
        else:
            try:
                PopUp.makePopUp("ERROR! Attempt to subtract non-Date or integer from Date (object " + str(otherDateOrInt) + ")\ntype of Minuend: " + str(type(self)) + "\ntype of Subtrahend: " + str(type(otherDateOrInt)), False)
            except:
                PopUp.makePopUp("ERROR! Attempt to subtract non-Date or integer from Date\ntype of Minuend: " + str(type(self)) + "\ntype of Subtrahend: " + str(type(otherDateOrInt)), False)
        
    def __str__(self):
        #return dateToString(self.year, self.month, self.day)
        return str(self.toTuple())
        
    def __repr__(self):
        return str(self)

    def __lt__(self, otherDate):
        if self.year < otherDate.year:
            return True
        elif self.year == otherDate.year:
            if self.month < otherDate.month:
                return True
            elif self.month == otherDate.month:
                if self.day < otherDate.day:
                    return True
                #elif self.day == otherDate.day:
                    #return True
        return False

    def __le__(self, otherDate):
        if self.year < otherDate.year:
            return True
        elif self.year == otherDate.year:
            if self.month < otherDate.month:
                return True
            elif self.month == otherDate.month:
                if self.day < otherDate.day:
                    return True
                elif self.day == otherDate.day:
                    return True
        return False

    def __eq__(self, otherDate):
        if type(self) != type(otherDate):
            return False
        if self.year == otherDate.year:
            if self.month == otherDate.month:
                if self.day == otherDate.day:
                    return True
        return False

    def __ne__(self, otherDate):
        if type(self) != type(otherDate):
            return True
        if self.year == otherDate.year:
            if self.month == otherDate.month:
                if self.day == otherDate.day:
                    return False
        return True

    def __gt__(self, otherDate):
        if self.year > otherDate.year:
            return True
        elif self.year == otherDate.year:
            if self.month > otherDate.month:
                return True
            elif self.month == otherDate.month:
                if self.day > self.day:
                    return True
                #elif self.day == otherDate.day:
                    #return True
        return False

    def __ge__(self, otherDate):
        if self.year > otherDate.year:
            return True
        elif self.year == otherDate.year:
            if self.month > otherDate.month:
                return True
            elif self.month == otherDate.month:
                if self.day > otherDate.day:
                    return True
                elif self.day == otherDate.day:
                    return True
        return False

    def __hash__(self):
        return hash((self.year, self.month, self.day))

    def toList(self):
        return [self.year, self.month, self.day]

    def toTuple(self):
        return (self.year, self.month, self.day)

    def toDay(self):
        return getDay(self.year, self.month, self.day)

    def toString(self):
        result = (self.toDay())[0:2] + ", " + dateToStringClass(self)
        return result

def maxOfDatumsClass(datumListe):
    if not isinstance(datumListe,list):
        return None
    if len(datumListe) == 0:
        return None
    result = datumListe[0]
    for element in datumListe:
        if result < element:
            result = element
    return result

def minOfDatumsClass(datumListe):
    if not isinstance(datumListe,list):
        return None
    if len(datumListe) == 0:
        return None
    result = datumListe[0]
    for element in datumListe:
        if result > element:
            result = element
    return result

def getDatumRangeClass(datum, länge):
    newDatum = copy.deepcopy(datum)
    result = []
    for i in range(0, länge):
        result.append(copy.deepcopy(newDatum))
        newDatum = newDatum + 1
    return result
*/
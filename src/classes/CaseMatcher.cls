/*
 * SFDC Case Matcher Server
 * 
 * Copyright (C) 2013 Victor Itkin
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

global class CaseMatcher
{
  static final Map<String, Pattern> regexPattern = new Map<String, Pattern> {};

  global class Email
  {
    webService String Subject {get; set;}
    webService String TextBody {get; set;}
    webService String HtmlBody {get; set;}
  }

  webService static String[] findCaseThreadIds(Email[] emails)
  {
    final Map<Integer, Id> emailIdCaseId = findCases(emails);
    final String[] caseThreadIds = new String[] {};

    for (Integer i = 0; i < emails.size(); i++)
    {
      caseThreadIds.add(emailIdCaseId.containsKey(i)
        ? String.format(Label.EmailToCaseThreadIdFormat,
                        new String[]
                        {
                          String.format('ref:{0}.{1}:ref',
                                        new String[]
                                        {
                                          trim(UserInfo.getOrganizationId()),
                                               trim(emailIdCaseId.get(i))
                                        })
                        })
        : '');
    }

    return caseThreadIds;
  }

  static String trim(Id id)
  {
    String idRight = ((String)id).substring(4, ((String)id).length() - 3);

    while (idRight.startsWith('0'))
    {
      idRight = idRight.substring(1);
    }

    return ((String)id).substring(0, 4) + idRight;
  }

  static Map<Integer, Id> findCases(Email[] emails)
  {
    final Map<String, Set<Integer>> possibleCaseNumberEmailIds
      = new Map<String, Set<Integer>>{};

    final Map<Integer, Id> emailIdCaseId = new Map<Integer, Id> {};

    for (Integer i = 0; i < emails.size(); i++)
    {
      if (!filter(emails[i]))
      {
        for (String possibleCaseNumber : findPossibleCaseNumbers(emails[i]))
        {
          if (!possibleCaseNumberEmailIds.containsKey(possibleCaseNumber))
          {
            possibleCaseNumberEmailIds.put(possibleCaseNumber,
                                           new Set<Integer> {i});
          }
          else
          {
            possibleCaseNumberEmailIds.get(possibleCaseNumber).add(i);
          }
        }
      }
    }

    if (!possibleCaseNumberEmailIds.isEmpty())
    {
      for (Case c : [SELECT CaseNumber 
      				 FROM Case 
      				 WHERE CaseNumber IN :possibleCaseNumberEmailIds.keySet() 
      				 ORDER BY CreatedDate])
      {
        for (Integer emailId : possibleCaseNumberEmailIds.get(c.CaseNumber))
        {
          emailIdCaseId.put(emailId, c.Id);
        }
      }
    }

    return emailIdCaseId;
  }

  static Boolean filter(Email email)
  {
    for(EmailToCaseMatchingRule__c rule : EmailToCaseMatchingRule__c.getAll().values())
    {
      if (rule.Filter__c)
      {
        if (rule.Subject__c && !isBlank(email.Subject))
        {
          if (getPattern(rule.Regex__c).matcher(email.Subject).find())
          {
            return true;
          }
        }

        if (rule.Body__c)
        {
          if (!isBlank(email.TextBody))
          {
            if (getPattern(rule.Regex__c).matcher(email.TextBody).find())
            {
              return true;
            }
          }

          if (!isBlank(email.HtmlBody))
          {
            if (getPattern(rule.Regex__c).matcher(email.HtmlBody).find())
            {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  static Set<String> findPossibleCaseNumbers(Email email)
  {
    final Set<String> possibleCaseNumbers = new Set<String> {};

    for(EmailToCaseMatchingRule__c rule : EmailToCaseMatchingRule__c.getAll().values())
    {
      if (!rule.Filter__c)
      {
        if (rule.Subject__c && !isBlank(email.Subject))
        {
          possibleCaseNumbers.addAll(findPossibleCaseNumbers(rule.Regex__c, email.Subject));
        }

        if (rule.Body__c)
        {
          if (!isBlank(email.TextBody))
          {
            possibleCaseNumbers.addAll(findPossibleCaseNumbers(rule.Regex__c, email.TextBody));
          }

          if (!isBlank(email.HtmlBody))
          {
            possibleCaseNumbers.addAll(findPossibleCaseNumbers(rule.Regex__c, email.HtmlBody));
          }
        }
      }
    }

    return possibleCaseNumbers;
  }

  static Set<String> findPossibleCaseNumbers(String regex, String input)
  {
    final Set<String> possibleCaseNumbers = new Set<String> {};
    final Matcher m = getPattern(regex).matcher(input);

    while (m.matches())
    {
      for (Integer i = 1; i <= m.groupCount(); i++)
      {
        possibleCaseNumbers.add(applyDisplayFormat(m.group(i)));
      }

      m.region(m.end(m.groupCount()), m.regionEnd());
    }

    return possibleCaseNumbers;
  }

  static String applyDisplayFormat(String possibleCaseNumber)
  {
    String possibleCaseNumberDisplayFormat = possibleCaseNumber;

    for (Integer i = possibleCaseNumberDisplayFormat.length(); i < 8; i++)
    {
      possibleCaseNumberDisplayFormat = '0' + possibleCaseNumberDisplayFormat;
    }

    return possibleCaseNumberDisplayFormat;
  }

  static Boolean isBlank(String s)
  {
    return s == null || s.trim().length() == 0;
  }

  static Pattern getPattern(String regex)
  {
    if (!regexPattern.containsKey(regex))
    {
      regexPattern.put(regex, Pattern.compile(regex));
    }

    return regexPattern.get(regex);
  }
}
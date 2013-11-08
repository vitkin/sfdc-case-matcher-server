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

@isTest
class CaseMatcherTests
{
  static testMethod void emailToCaseMatchingTest()
  {
    final EmailToCaseMatchingRule__c[] emailToCaseMatchingRules 
      = new EmailToCaseMatchingRule__c[] {};
    
    Case c = new Case();
    final CaseMatcher.Email[] emails = new CaseMatcher.Email[] {};
    String[] caseThreadIds;

    emailToCaseMatchingRules.add(new EmailToCaseMatchingRule__c(
      Name = 'Case Thread Id',
      Regex__c = 'ref:[0-9a-zA-Z]{4,15}\\.[0-9a-zA-Z]{4,15}:ref',
      Subject__c = true,
      Body__c = true,
      Filter__c = true));

    emailToCaseMatchingRules.add(new EmailToCaseMatchingRule__c(
      Name = 'Any Integer',
      Regex__c = '(?s).*?(\\d+).*',
      Subject__c = true));

    delete [SELECT Id FROM EmailToCaseMatchingRule__c];
    insert emailToCaseMatchingRules;

    insert c;
    c = [SELECT CaseNumber From Case WHERE Id = :c.Id];

    emails.add(new CaseMatcher.Email());
    emails[0].Subject = 'Subject';
    emails[0].TextBody = 'TextBody';
    emails[0].HtmlBody = 'HtmlBody';

    emails.add(new CaseMatcher.Email());
    emails[1].Subject = 'ref:0000.0000:ref';

    emails.add(new CaseMatcher.Email());
    emails[2].Subject = c.CaseNumber;

    caseThreadIds = CaseMatcher.findCaseThreadIds(emails);

    System.assertEquals(emails.size(), caseThreadIds.size());
    System.assertEquals(0, caseThreadIds[0].length());
    System.assertEquals(0, caseThreadIds[1].length());
    System.assertNotEquals(0, caseThreadIds[2].length());
  }
}
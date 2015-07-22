<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Product_Assignment_To_Outfit</fullName>
        <description>Product Assignment To Outfit</description>
        <protected>false</protected>
        <recipients>
            <recipient>govind.outfit@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Admin_Outfit_Request_Notification</template>
    </alerts>
    <rules>
        <fullName>Outfit Notification</fullName>
        <actions>
            <name>Product_Assignment_To_Outfit</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Assign_Products_To_Outfit</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Outfit__c.Status__c</field>
            <operation>equals</operation>
            <value>Assigned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Assign_Products_To_Outfit</fullName>
        <assignedTo>govind.outfit@gmail.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Assign Products To Outfit</subject>
    </tasks>
</Workflow>

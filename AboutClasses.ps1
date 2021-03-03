function prompt(){"PS> "}
break
<#
Kevin Marquette
@kevinmarquette

PowerShell Classes
#>



# Objects
Get-Service

# Single Instance
$service = Get-Service Spooler

# Properties
$service | Format-List -Property *

# Definition (Properties and Methods)
$service | Get-Member

# Type
$service.GetType()

$service.GetType().FullName


# Returning data
# Hashtable
function Get-Hashtable {
    @{
        First = 'Kevin'
        Last = 'Marquette'
        City = 'Belleve'
    }
}

Get-Hashtable

# PSCustomObject
function Get-PSCustomObject {
    [pscustomobject]@{
        First = 'Kevin'
        Last = 'Marquette'
        City = 'Belleve'
    }
}

Get-PSCustomObject



# Class Instance
Class Person {
    [String] $First
    [String] $Last
    [String] $City
}

function Get-Instance {
    [Person]@{
        First = 'Kevin'
        Last = 'Marquette'
        City = 'Belleve'
    }
}

Get-Instance

$instance = Get-Instance
$instance | Get-Member



# Creating Instances

[Person]@{
    First = 'Kevin'
    Last = 'Marquette'
    City = 'Belleve'
}

$person = [Person]::new()
$person.First = 'Alex'
$person.Last = 'Marquette'
$person.City = 'Irvine'


# Casting
$hashtable = @{
    First = 'Kevin'
    Last = 'Marquette'
    City = 'Belleve'
}

[person]$hashtable

$psobject = [PSCustomObject]@{
    First = 'Kevin'
    Last = 'Marquette'
    City = 'Belleve'
}
[person]$psobject


# Default values

# Class Instance
Class Person2 {
    [String] $First = 'Kevin'
    [String] $Last = 'Marquette'
    [String] $City = 'Bellevue'
}

[Person2]::new()


[Person2]@{
    First = 'Charis'
}




# Methods
# Return type, return keyword, void keyword
Class Person3 {
    # Properties
    [String] $First = 'Kevin'
    [String] $Last = 'Marquette'
    [String] $City = 'Bellevue'

    # Methods
    [string] GetFullName()
    {
        return ("{1}, {0}" -f $this.First, $this.Last)
    }

    [void] Wave()
    {
        Write-Verbose -Verbose ("{0} waves hello" -f $this.first )
    }
}

$person  = [Person3]::new()
$person.GetFullName()
$person.Wave()

# ToString()
Class Person4 {
    [String] $First = 'Kevin'
    [String] $Last = 'Marquette'
    [String] $City = 'Bellevue'

    [string] GetFullName()
    {
         return ("{1}, {0}" -f $this.First, $this.Last)
    }

    [string] ToString()
    {
         return $this.GetFullName()
    }
}

$person3 = [Person3]::new()
"Person 3 [$person3]"
$person4 = [Person4]::new()
"Person 4 [$person4]"



# Constructor and $this

Class Person5 {
    [String] $First
    [String] $Last
    [String] $City

    Person5($First,$Last,$City)
    {
        $this.First = $First
        $this.Last = $Last
        $this.City = $City
    }
    #Person5(){}
}

[Person5]::new()

[Person5]::new('Kevin','Marquette','Bellevue')




# Complex Example: test results

class TestItem
{
    [bool]$TestResult
    [string]$Message

    TestItem([string]$Message, [bool]$TestResult)
    {
        $this.Message = $Message
        $this.TestResult = $TestResult
    }

    [string] ToString()
    {
        return $this.Message
    }
}

class TestResult
{
    [int]$TotalCount
    [int]$PassedCount
    [int]$FailedCount
    [System.Collections.Generic.IList[TestItem]]$TestResult

    TestResult ()
    {
        $this.TestResult = [System.Collections.Generic.List[TestItem]]::New()
        $this.FailedCount = 0
        $this.PassedCount = 0
        $this.TotalCount = 0
    }

    [void]Failed([String]$Message)
    {
        $this.AddResult($Message, $false)
    }

    [void]Passed([String]$Message)
    {
        $this.AddResult($Message, $true)
    }

    [void]AddResult([String]$Message, [bool]$Result)
    {
        $testItem = [TestItem]::New($Message, $Result)
        $this.TotalCount += 1
        if ($Result)
        {
            $this.PassedCount += 1
            Write-Verbose "[+]Passed $Message" -Verbose
        }
        else
        {
            $this.FailedCount += 1
            Write-Verbose "[-]Failed $Message" -Verbose
        }
        $this.TestResult.Add($testItem)
    }
}


$results = [TestResult]::New()
$results


$results.Passed('Created an instance')
$results.Passed('Added some tests')
$results.Failed('ops, I did it again')
$results.AddResult('something random', ($true,$false | Get-Random))

$results

$results.TestResult

#example
Code .\Modules\F5\Classes\HealthMonitor.ps1



# Checkpoint/Review

# Advanced Concept: Inheritance

Class BasePerson {
    [String] $First = 'Kevin'
    [String] $Last = 'Marquette'
    [String] $City = 'Bellevue'

    [string] GetFullName()
    {
         return ("{1}, {0}" -f $this.First, $this.Last)
    }

    [string] ToString()
    {
         return $this.GetFullName()
    }
}

Class Student : BasePerson {
    [float]$GPA = 4.0
}

[Student]@{
    First = 'Alex'
}


# method override

Class Teacher : BasePerson {
    [string] GetFullName()
    {
         return ("Mr. {0}" -f $this.Last)
    }
}

$teacher = [Teacher]::new()
$teacher.GetFullName()

"Hello $teacher!"

@(
    [Teacher]::new()
    [Student]@{First = 'Alex'}
    [Student]@{First = 'Charis'}
) | Foreach-Object {"Hello $_!"}


if($teacher -is [BasePerson]){
    "I'm more than a human shield! - Yeah, that's right. You are."
}
if($teacher -is [Teacher]){
    "You're a perfect, impenetrable suit of human armor, Morty,"
}

# Custom Exceptions

class ZigerionException : System.Exception
{
    ZigerionException() : base("These Zigerions are always trying to scam me out of my secrets, but they made a big mistake this time, Morty."){}
    ZigerionException( [string]$Message ) : base( $Message ){}
}

throw [ZigerionException]::new()



# Custom Validators
# https://powershellexplained.com/2017-02-20-Powershell-creating-parameter-validators-and-transforms

class ValidatePathExistsAttribute : System.Management.Automation.ValidateArgumentsAttribute
{
    [void] Validate([object]$arguments, [System.Management.Automation.EngineIntrinsics]$engineIntrinsics)
    {
        $path = $arguments
        if([string]::IsNullOrWhiteSpace($path))
        {
            Throw [System.ArgumentNullException]::new()
        }
        if(-not (Test-Path -Path $path))
        {
            Throw [System.IO.FileNotFoundException]::new()
        }        
    }
}

function Test-Validator
{
    [cmdletbinding()]
    param(
        [ValidatePathExists()]
        $Path
    )
    return $Path
}	

Test-Validator -Path C:\nofolder

Test-Validator -Path C:\Windows


# Pipeline type validation

function Test-Pipeline 
{
    param(
        [Parameter(ValueFromPipeline)]    
        [BasePerson]$person
    )
    process{
        "Hello $person!"
    }
}

"Marquette, Crystal" | Test-Pipeline

[teacher]::new() | Test-Pipeline 

@(
    [teacher]::new()
    [student]@{First = 'Alex'}
    [student]@{First = 'Charis'}
) | Test-Pipeline 


# Parameter Constructors, Overloading

Class Person6 {
    [String] $First
    [String] $Last
    Person6(){}
    Person6($First,$Last)
    {
        $this.First = $First
        $this.Last = $Last
    }
    
    Person6($FullName)
    {
        $this.Last, $this.First = $FullName -split ', '
    }
}

[Person6]::new("Marquette, Crystal")

function Test-Pipeline6 
{
    param(
        [Parameter(ValueFromPipeline)]    
        [Person6]$Person
    )
    process{
        $Person
    }
}

"Marquette, Crystal" | Test-Pipeline6


# Constructor Objects
Import-Module -Name Microsoft.PowerShell.LocalAccounts

$local = Get-LocalUser $env:username
$local | Format-List -Property *

$local | Get-Member




Class Person7 {
    [String] $First
    [String] $Last
    Person7(){}
    Person7($First,$Last)
    {
        $this.First = $First
        $this.Last = $Last
    }
    
    Person7([String]$FullName)
    {
        $this.Last, $this.First = $FullName -split ', '
    }

    Person7([Microsoft.PowerShell.Commands.LocalUser]$LocalUser)
    {
        $this.First, $this.Last = $LocalUser.FullName -split ' '
    }
}

[Person7]::new("Marquette, Crystal")
[Person7]::new($local)

function Test-Pipeline7 
{
    param(
        [Parameter(ValueFromPipeline)]    
        [Person7]$Person
    )
    process{
        $Person
    }
}
"Marquette, Crystal", $local | Test-Pipeline7


# Casting Revisited
[Person7]"Marquette, Crystal"
[Person7]$local


# More constructor magic

class Duration
{
    [timespan]$Timespan

    Duration([timespan]$Timespan)
    {
        $this.Timespan = $Timespan
    }
    Duration([DateTime]$Date)
    {
        $this.Timespan = [Duration]::FromDate($Date)
    }
    Duration([String]$Input)
    {
        $this.Timespan = [Duration]::FromString($Input)
    }

    static [timespan]FromDate([DateTime]$Date)
    {
        return $Date - (get-date)
    }

    static [timespan]FromString([string]$Input)
    {
        try
        {
            if($time = [timespan]::Parse($Input))
            {
                return $time
            }
        }catch{}
        try{
            if($date = [datetime]::Parse($Input))
            {
                return [Duration]::FromDate($date)
            }
        }catch{}
        throw [Exception]::new("Could not parse a duration from [$Input]")
    }

    [string] ToString()
    {
        return $this.Timespan.ToString()
    }
}

[duration]"00:00:30"
[duration]"00:05:00"
[duration]"3/2/2021 19:00:00"

Function Start-SleepDuration
{
    param(
        [Parameter(Position=0)]
        [duration]$Duration
        )
    $seconds = $Duration.Timespan.TotalSeconds
    Write-Verbose -Verbose "Sleeping for $Duration"
    Start-Sleep -Seconds $seconds
}

Start-SleepDuration "00:00:5"
Start-SleepDuration (Get-Date).AddSeconds(5)
Start-SleepDuration "3/2/2021 19:00:00"
# DSC Resource

enum FirewallState
{
    On
    Off
}

[DscResource()]
class Firewall
{
	[DscProperty(Key)]
	[FirewallState]
	$FirewallState

	[void] Set()
	{
		If ($this.FirewallState -eq [FirewallState]::Off)
		{
			netsh advfirewall set allprofiles state off
			Write-Verbose "Set firewall to $($this.FirewallState)"
		}
		ElseIf ($this.FirewallState -eq [FirewallState]::On)
		{
			netsh advfirewall set allprofiles state on
			Write-Verbose "Set firewall to $($this.FirewallState)"
		}
        Else
        {
            Write-Verbose "Invalid option $($this.firewallState) selected.  No action taken"
        }
	}

	[bool] Test()
	{
		$currValue = (netsh advfirewall show allprofiles state)
        $offCount = ($currValue | select-string 'off').count

        if (($offCount -eq 3) -and ($this.FirewallState -eq [FirewallState]::Off))
        {
            Return $true
        }
        if (($offCount -eq 0) -and ($this.FirewallState -eq [FirewallState]::On))
        {
            Return $true
        }
        Return $false
	}

	[Firewall] Get()
	{
		$currValue = (netsh advfirewall show allprofiles state)
        $offCount = ($currValue | select-string 'off').count

        If ($offCount -eq 3)
        {
            $this.firewallState = [FirewallState]::off
        }
        Else
        {
            $this.firewallState = [FirewallState]::on
        }

		Return $this
	}
}

# SOLID principals and Design patterns
# http://www.mcdonaldland.info/files/designpatterns/designpatternscard.pdf

# Real World Examples


<#
Developing with PowerShell Classes: Here be Dragons by Brandon Olin
https://www.youtube.com/watch?v=i1DpPU_xxBc
#>
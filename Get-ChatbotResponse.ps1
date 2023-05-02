Add-Type -AssemblyName PresentationFramework

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ChatBot" Height="450" Width="800">
    <Grid>
        <TextBox x:Name="txtChat" IsReadOnly="True" VerticalScrollBarVisibility="Auto" Margin="10,10,10,50" />
        <TextBox x:Name="txtInput" Margin="10,0,110,10" VerticalAlignment="Bottom" />
        <Button x:Name="btnSend" Content="Send" Margin="0,0,10,10" Width="100" Height="30" HorizontalAlignment="Right" VerticalAlignment="Bottom" />
    </Grid>
</Window>
"@

$reader = [System.Xml.XmlNodeReader]::new([System.Xml.Xml]::XmlTextReader.Create([System.IO.StringReader]::new($xaml)))
$window = [System.Windows.Markup.XamlReader]::Load($reader)

function Get-ChatbotResponse($input) {
    switch -regex ($input) {
        '(?i)hello|hi|hey' { return 'Hello! How can I help you today?' }
        '(?i)bye|goodbye|exit' { return 'Goodbye! Have a great day!' }
        '(?i)how are you' { return 'I am just a script, but I am functioning well. Thanks for asking!' }
        '(?i)what is your name' { return 'I am a simple PowerShell chatbot. You can call me ChatBot.' }
        default { return "I'm not sure how to respond to that. Can you please try something else?" }
    }
}

$window.FindName("btnSend").Add_Click({
    $input = $window.FindName("txtInput").Text
    $window.FindName("txtChat").Text += "You: $input`r`n"
    $response = Get-ChatbotResponse $input
    $window.FindName("txtChat").Text += "ChatBot: $response`r`n"
    $window.FindName("txtInput").Text = ""
    $window.FindName("txtInput").Focus()
})

$window.FindName("txtInput").Add_PreviewKeyDown({
    if ($_.Key -eq "Return") {
        $window.FindName("btnSend").RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Primitives.ButtonBase]::ClickEvent))
    }
})

$window.ShowDialog() | Out-Null

<#################################################################################
    Render-String

    Copyright (C) 2022  Christopher Andrews

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#################################################################################>

<#
    .SYNOPSIS
        Renders a ASCII style string.

    .DESCRIPTION
        This function will render a stylistic ASCII representation of an input string drawn in any font/style.

    .INPUTS
        The text to generate.

    .OUTPUTS
        Returns a string containing the generated output.

    .PARAMETER In
        The target string to render.

    .PARAMETER FontSize
        The font size to use when rendering the string.

    .PARAMETER FontName
        The desired font face to use when rendering the string.
        Default is Lucida Sans Typewriter.

    .PARAMETER fontStyle
        Specifies the font style to use when rendering the string.
        Valid values are: Bold, Regular, Italic, Strikeout, Underline.
        
    .PARAMETER Fill
        The fill character to use when generating the ASCII output.

    .PARAMETER X1
        Specifies how much to reduce the left side of the rendered bounding box.
        The default is 0.

    .PARAMETER X2
        Specifies how much to reduce the right side of the rendered bounding box.
        The default is 0.

    .PARAMETER Y1
        Specifies how much to reduce the top of the rendered bounding box.
        The default is 0.

    .PARAMETER Y2
        Specifies how much to reduce the bottom of the rendered bounding box.
        The default is 0.

    .PARAMETER Reference
        When using -NoKerning, this character is used to determine the maximum dimensions of each character.
        Use the biggest character that will be used.

    .PARAMETER NoKerning
        If specified, this will render each character individually causing them to be equally spaced.
        When -NoKerning is not used, the entire input is rendered with kerning.

    .EXAMPLE
        Render the current time.

        PS> .\Render-String (Get-Date).ToString("hh:mm:ss")

        Output:

         @@@@   @@@@@@             @@@@     @@@           @@@@@@  @@@@@@@
        @@@@@   @@  @@@            @@@@    @@@@           @@@         @@@
          @@@       @@@   @@@     @@@@@   @@@@@    @@@    @@@        @@@
          @@@       @@    @@@    @@@@@@  @@@@@@    @@@    @@@@@      @@
          @@@      @@@          @@@ @@@  @@ @@@              @@@    @@@
          @@@     @@@           @@@@@@@@@@@@@@@@             @@@   @@@
          @@@    @@@                @@@     @@@              @@@   @@@
          @@@   @@@       @@@       @@@     @@@    @@@       @@@   @@
        @@@@@@@ @@@@@@@   @@@       @@@     @@@    @@@    @@@@@   @@@

    .EXAMPLE

        PS> .\Render-String Test -FontName "Courier New" -fontStyle Bold

        Output:

        @@@@@@@@@@@@                              @@@@
        @@@@@@@@@@@@                              @@@@
        @@@ @@@@@@@@                              @@@@
        @@@ @@@@@@@@    @@@@@@       @@@@@@@@   @@@@@@@@@@@
        @@@ @@@@ @@@  @@@@@@@@@@    @@@@@@@@@   @@@@@@@@@@@
            @@@@     @@@@    @@@@  @@@@   @@@     @@@@
            @@@@     @@@@@@@@@@@@  @@@@@@@        @@@@
            @@@@     @@@@@@@@@@@@   @@@@@@@@@     @@@@
            @@@@     @@@                 @@@@@    @@@@
            @@@@     @@@@@   @@@@  @@@    @@@@    @@@@  @@@@
         @@@@@@@@@    @@@@@@@@@@@  @@@@@@@@@@     @@@@@@@@@@
         @@@@@@@@@     @@@@@@@@    @@@@@@@@@        @@@@@@


    .EXAMPLE

        Constrain the bounding box so only a thin border remains. 
        In the above example, the font drawing functions place the text in quite a large bounding box.
        This can be controlled using the boxing constraints (-X1, -X2, -Y1, -Y2).

        PS> .\Render-String Test -FontName "Courier New" -fontStyle Bold -X1 3 -X2 3 -Y1 5 -Y2 8 |
                Write-Host -ForegroundColor Red -BackgroundColor Black


    .EXAMPLE

        PS> .\Render-String Question! -FontName "Calibri Light" -FontSize 14 -FontStyle Underline -Fill '?'

        Output:

                                                         ???                      ???
              ??????                                     ???                      ???
             ???   ???                             ???                            ???
            ???     ??                             ???                            ???
            ??      ???  ??   ???   ??????  ????? ?????? ??   ??????   ???????    ???
           ???      ???  ??   ???  ???  ??? ?? ??? ???   ??  ???  ???  ???? ???   ???
           ???      ???  ??   ???  ??   ??????     ???   ??  ??    ??  ???  ???   ???
           ???      ???  ??   ??? ???    ?? ???    ???   ?? ???    ??? ??   ???   ???
           ???      ???  ??   ??? ?????????  ????  ???   ?? ???    ??? ??   ???   ???
            ??      ???  ??   ??? ???          ??? ???   ?? ???    ??? ??   ???   ???
            ???     ??   ???  ???  ??           ?? ???   ?? ???    ??  ??   ???
             ???  ????   ??? ????  ???  ?????? ??? ???   ??  ???  ???  ??   ???   ???
              ?????????   ???????   ??????  ?????   ???? ??   ??????   ??   ???   ???
                      ???

           ????????????????????????????????????????????????????????????????????????????


    .EXAMPLE

        PS> .\Render-String "<`"J" -FontName Wingdings -Fill '#' -NoKerning

        Output:

                                                           #######
         #################      #####                    ####    ###
         ## ##       ## ##      ## ###           #####  ###       ###
         ## ##       ## ##      ##  ##         ######  ###         ###
         ## ##       ## ##      ### ###      ######    ####### #### ###
         ## ##       ## ##        #####     #####      ## #### ####  ##
         ## ##       ## ##          ####  #####       ###            ##
         ## ##       ## ##            ########        ###            ###
         ## ########### ##             #####          ### ##      ## ###
         ##             ##            ########        ### ##      ## ##
         ##  #########  ##          ####   ####        ## ###    ### ##
         ##  ## ######  ##        ######    #####      ### ###  ### ###
         ##  ## ######  ##       ###  ##      #####    ###  ###### ###
         ##  ## ######  ##      ##   ###        #####   ###       ###
          ## ## ######  ##      ##  ###          #####   ####    ###
           ###############      #####                      #######


#>

[CmdletBinding(DefaultParameterSetName = "WithKerning")]
Param(
    [Parameter(
        Mandatory,
        Position = 0,
        ValueFromPipeLine
    )]
    [String]$In,

    [Parameter(Position = 1)]
    [ValidateRange(1,1000)]
    [Int]$FontSize = 16,

    [Parameter(Position = 2)]
    [String]$FontName = "Lucida Sans Typewriter",

    [Parameter(Position = 3)]
    [ValidateSet("Bold", "Regular", "Italic", "Strikeout", "Underline")]
    [String]$FontStyle = "Regular",

    [Parameter(Position = 4)]
    [Char]$Fill = "@",

    [Parameter(Position = 5)]
    [ValidateRange(0,1000)]
    [Int]$X1 = 0,

    [Parameter(Position = 6)]
    [ValidateRange(0,1000)]
    [Int]$X2 = 0,

    [Parameter(Position = 7)]
    [ValidateRange(0,1000)]
    [Int]$Y1 = 0,

    [Parameter(Position = 8)]
    [ValidateRange(0,1000)]
    [Int]$Y2 = 0,

    [Parameter(
        Mandatory,
        ParameterSetName = "NoKerning"
    )]
    [Switch]$NoKerning,

    [Parameter(ParameterSetName = "NoKerning")]
    [Char]$Reference = "W"
)

Begin{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
}Process{

    #Create specified font
    $Font = [Drawing.Font]::new($FontName, $FontSize, [Drawing.FontStyle]$FontStyle)

    # Create a temp bitmap to calculate character dimensions.
    $Bmp = [Drawing.Bitmap]::new(1,1)

    # Create a graphics object to draw to the bitmap.
    $Graphics = [Drawing.Graphics]::FromImage($Bmp)
    $Graphics.PageUnit = [Drawing.GraphicsUnit]::Pixel

    # Determine test target.
    $TestString = if($NoKerning){
        $Reference
    }else{
        $In
    } 

    # Calculate dimensions
    $CharSize = $graphics.MeasureString($TestString, $Font)
    $CharWidth = [Int]$CharSize.Width # if kerning, entire string length
    $Height = [Int]$CharSize.Height

    $Width = if($NoKerning){
        $In.Length * $CharWidth
    }else{
        $CharWidth
    }

    # Dispose pre-calculation objects.
    $Graphics.Dispose()
    $Bmp.Dispose()

    # Recreate drawing objects to target dimensions.
    $Bmp = [Drawing.Bitmap]::new($Width, $Height)
    $Graphics = [Drawing.Graphics]::FromImage($Bmp)

    # Draw the string
    if($NoKerning){
        ForEach($Idx in 0..($In.Length)){
            $Graphics.DrawString($In[$Idx], $Font, [System.Drawing.Brushes]::Black, $CharWidth * $Idx, 0)
        }
    }else{
        $Graphics.DrawString($In, $Font, [System.Drawing.Brushes]::Black, 0, 0)
    }

    # Generate the ASCII string representing the image.
    $Rows = ForEach($YPixel in $Y1..($Height - 1 - $Y2)){
        $Row = ForEach($XPixel in $X1..($Width-1 - $X2)){

            if($bmp.GetPixel($XPixel, $YPixel).A){
                $fill
            }else{
                " "
            }
        }
        $Row -Join ""
    }

    $Rows -join "`n"

    # Destroy system objects.
    $Graphics.Dispose();
    $Bmp.Dispose();
    $Font.Dispose()
}

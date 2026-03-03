// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// A Page that allows the user to enter a password.
/// </summary>
page 50074 "HORECA Password Dialog"
{
    Extensible = false;
    Caption = 'Enter Password';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {

            field(Password; PasswordValue)
            {
                ApplicationArea = All;
                Caption = 'Password';
                ExtendedDatatype = Masked;
                ToolTip = 'Specifies the password for this task.';

            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        RequiresPasswordValidation := true;
        RequiresPasswordConfirmation := true;
    end;

    trigger OnOpenPage()
    begin

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin

        end;
    end;

    var

        PasswordMismatchErr: Label 'The passwords that you entered do not match.';
        PasswordValue: Text;

        RequiresPasswordValidation: Boolean;
        RequiresPasswordConfirmation: Boolean;

    /// <summary>
    /// Gets the password value typed on the page.
    /// </summary>
    /// <returns>The password value typed on the page.</returns>

    procedure GetPasswordValue(): Text
    begin
        exit(PasswordValue);
    end;




}


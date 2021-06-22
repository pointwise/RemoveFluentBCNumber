# RemoveFluentBCNumber
Copyright 2021 Cadence Design Systems, Inc. All rights reserved worldwide.

This script takes a .cas file exported as either ANSYS FLUENT or ANSYS FLUENT (legacy) from Pointwise and removes the number appended to the end of each boundary condition name. It applies to all BC types except interior and symmetry. If the BC spans multiple VCs, then the number is left to avoid duplicate BC names from occuring. 

## Disclaimer
This file is licensed under the Cadence Public License Version 1.0 (the "License"), a copy of which is found in the LICENSE file, and is distributed "AS IS." 
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, CADENCE DISCLAIMS ALL WARRANTIES AND IN NO EVENT SHALL BE LIABLE TO ANY PARTY FOR ANY DAMAGES ARISING OUT OF OR RELATING TO USE OF THIS FILE. 
Please see the License for the full text of applicable terms.

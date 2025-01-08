function ker = hist_isect()

% RBF
%
% Construct a Gaussian radial basis function (RBF) kernel object,
%
%    K(x1, x2) = exp(-gamma.*sum((x1 - x2).^2))
%
% Examples:
%
%    % default constructor (spherical RBF kernel, gamma = 1.0)
%
%    ker1 = rbf;
%
%    % copy constructor
%
%    ker2 = rbf(ker1);
%
%    % construct spherical RBF kernel, gamma = 0.5
%
%    ker3 = rbf(0.5);

%
% File        : @rbf/rbf.m
%
% Date        : Tuesday 12th September 2000 
%
% Author      : Dr Gavin C. Cawley
%
% Description : Constructor for a class implementing a Gaussian radial basis
%               function kernel, forming part of a Matlab toolbox implementing
%               Vapnik's Support Vector Machine, as described in [1].
%
% References  : [1] V.N. Vapnik,
%                   "The Nature of Statistical Learning Theory",
%                   Springer-Verlag, New York, ISBN 0-387-94559-8,
%                   1995.
%
% History     : 07/07/2000 - v1.00
%               12/09/2000 - v1.01 minor improvements to comments and help
%                                  messages
%
% Copyright   : (c) Dr Gavin C. Cawley, September 2000.
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program; if not, write to the Free Software
%    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
%

if nargin == 0

    ker.dummy = [];
    ker       = class(ker, 'hist_isect');
elseif isa(a, 'hist_isect');

    % this is the copy constructor

    ker = a;

else

    % there are no other constructors

    help linear

end

% bye bye...


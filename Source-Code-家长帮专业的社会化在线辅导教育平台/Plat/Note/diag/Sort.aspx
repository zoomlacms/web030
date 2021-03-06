﻿<%@ Page Language="C#" MasterPageFile="~/Common/Common.master" AutoEventWireup="true" CodeBehind="Sort.aspx.cs" Inherits="ZoomLaCMS.Plat.Note.Diag.Sort" %>
<asp:Content ContentPlaceHolderID="head" runat="server">
    <title>排序</title>
</asp:Content>
<asp:Content ContentPlaceHolderID="Content" runat="server">
    <div ng-app="app" style="min-height:400px;">
        <ul id="formul" class="list-unstyled" ng-controller="NoteCtrl" >
            <li class="boders" ng-repeat="item in comlist | orderBy: 'orderID'">
                <img ng-src="{{getImgByType(item)}}" data-id="{{item.id}}"/>
            </li>
            <li style="clear:both;display:none;"></li>
        </ul>
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="Script" runat="server">
    <link rel="stylesheet" href="/App_Themes/V4user.css" />
    <script src="/JS/Plugs/angular.min.js"></script>
    <script src="/JS/jquery-ui.min.js"></script>
    <script src="/JS/Controls/ZL_Array.js"></script>
    <script>
        var scope = null;
        angular.module("app", [])
        .controller("NoteCtrl", function ($scope, $compile) {
            scope = $scope;
            $scope.comlist = parent.scope.comMod.comlist;
            $scope.comlist = [];
            $scope.getImgByType = parent.scope.getImgByType;
            $("#formul").sortable({
                placeholder: "highlight",
                cursor: 'crosshair',
                update: function (evt) {//拖拽完成后
                    parent.scope.$apply(function () {
                        $("#formul li img").each(function (i, v) {
                            var obj = parent.scope.comMod.comlist.GetByID($(this).data('id'));
                            obj.orderID = i + 1;
                        });
                    });
                }
            });
        });
        function update() {
            scope.comlist = parent.scope.comMod.comlist;
            scope.$digest();
        }
    </script>
</asp:Content>

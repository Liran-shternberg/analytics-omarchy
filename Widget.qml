import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "analytics-omarchy"

  property string cpuUsage: ""
  property real cpuPercent: 0
  property string ramUsed: ""
  property real ramPercent: 0

  // Green (idle) -> yellow -> red (max) as usage climbs.
  function heatColor(pct) {
    var t = Math.min(1, Math.max(0, pct / 100))
    return Qt.hsla(0.33 * (1 - t), 0.72, 0.52, 1.0)
  }

  function openBtop() {
    if (root.bar) root.bar.run("omarchy launch or focus tui btop")
  }

  // Whole widget is one click target.
  function triggerPress(button) {
    root.openBtop()
  }

  onBarChanged: {
    if (root.bar && root.bar.registerClickTarget) root.bar.registerClickTarget(root)
  }

  implicitWidth: barRow.implicitWidth
  implicitHeight: barRow.implicitHeight

  Component.onCompleted: statsProc.running = true

  Timer {
    id: poll
    interval: 3000
    repeat: true
    running: true
    onTriggered: statsProc.running = true
  }

  Process {
    id: statsProc
    running: false
    command: ["omarchy-system-stats"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.parseStats(text)
    }
  }

  function parseStats(raw) {
    var lines = String(raw).split("\n")
    for (var i = 0; i < lines.length; i++) {
      var parts = lines[i].split("\t")
      if (parts[0] === "cpu" && parts.length > 1) {
        root.cpuUsage = parts[1]
        root.cpuPercent = parseFloat(parts[1]) || 0
      } else if (parts[0] === "memory" && parts.length > 1) {
        var seg = parts[1].split(" / ")
        root.ramUsed = seg[0] || ""
        var used = parseFloat(seg[0]) || 0
        var total = parseFloat(seg[1]) || 0
        root.ramPercent = total > 0 ? (used / total) * 100 : 0
      }
    }
  }

  Row {
    id: barRow
    spacing: Style.space(8)

    Row {
      spacing: Style.space(2)

      Text {
        id: cpuText
        text: root.cpuUsage
        color: root.heatColor(root.cpuPercent)
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption
        anchors.verticalCenter: parent.verticalCenter
      }

      BarIconButton {
        bar: root.bar
        text: "󰍛"
        onPressed: function(b) {
          root.openBtop()
        }
      }
    }

    Row {
      spacing: Style.space(2)

      Text {
        id: ramText
        text: root.ramUsed
        color: root.heatColor(root.ramPercent)
        font.family: root.bar ? root.bar.fontFamily : Style.font.family
        font.pixelSize: Style.font.caption
        anchors.verticalCenter: parent.verticalCenter
      }

      BarIconButton {
        bar: root.bar
        text: "󰘚"
        onPressed: function(b) {
          root.openBtop()
        }
      }
    }
  }
}
